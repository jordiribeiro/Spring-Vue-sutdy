#!/bin/bash
# SetupProject.sh
# Este script configura o projeto full-stack:
#  - Verifica se Java 11 ou superior, Maven, Node.js, npm e Vue CLI estão instalados.
#  - Se não estiverem instalados, tenta instalá-los utilizando apt-get ou brew.
#  - Cria um projeto Vue (se não existir) chamado "my-vue-app" utilizando o Vue CLI.
#  - Copia o componente "frontend/ProductCrud.vue" para o diretório de componentes do projeto Vue.
#  - Atualiza o arquivo "src/App.vue" do projeto Vue para integrar o componente ProductCrud.

# Função para garantir que um comando exista, instalando-o se necessário
function ensure_command() {
    local cmd="$1"
    local pkg="$2"
    local friendly="$3"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$friendly não está instalado. Tentando instalar..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y "$pkg"
        elif command -v brew >/dev/null 2>&1; then
            brew install "$pkg"
        else
            echo "Gerenciador de pacotes não encontrado. Por favor, instale $friendly manualmente."
            exit 1
        fi
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Instalação de $friendly falhou. Por favor, instale manualmente."
            exit 1
        fi
    fi
}

echo "Verificando pré-requisitos..."

# Verificar Java
ensure_command java openjdk-11-jdk "Java 11 ou superior"

# Obter versão do Java (supondo que a saída seja algo como "11.0.12")
JAVA_VERSION=$(java -version 2>&1 | awk -F[\".] '/version/ {print $2}')
if [ "$JAVA_VERSION" -lt 11 ]; then
    echo "Java 11 ou superior é necessário. Versão encontrada: $JAVA_VERSION"
    exit 1
else
    echo "Java versão $JAVA_VERSION detectado."
fi

# Verificar Maven
ensure_command mvn maven "Maven"

# Verificar Node.js
ensure_command node nodejs "Node.js"

# Verificar npm
ensure_command npm npm "npm"

# Verificar Vue CLI; se não estiver instalado, instalá-lo globalmente via npm
if ! command -v vue >/dev/null 2>&1; then
    echo "Vue CLI não encontrado. Instalando Vue CLI globalmente via npm..."
    npm install -g @vue/cli
    if ! command -v vue >/dev/null 2>&1; then
        echo "Instalação do Vue CLI falhou. Por favor, instale-o manualmente."
        exit 1
    fi
fi

echo "Todos os pré-requisitos estão instalados."

# Configurar projeto Vue
VUE_PROJECT_DIR="my-vue-app"

if [ ! -d "$VUE_PROJECT_DIR" ]; then
    echo "Criando projeto Vue '$VUE_PROJECT_DIR'..."
    vue create "$VUE_PROJECT_DIR" --default --packageManager npm
else
    echo "Projeto Vue '$VUE_PROJECT_DIR' já existe. Pulando a criação."
fi

# Copiar o componente ProductCrud.vue para o diretório de componentes
SOURCE_COMPONENT="frontend/ProductCrud.vue"
DEST_DIR="$VUE_PROJECT_DIR/src/components"

if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi

echo "Copiando ProductCrud.vue para $DEST_DIR..."
cp "$SOURCE_COMPONENT" "$DEST_DIR/"

# Atualizar App.vue para integrar o componente ProductCrud
APP_VUE_PATH="$VUE_PROJECT_DIR/src/App.vue"

cat > "$APP_VUE_PATH" <<EOL
<template>
  <div id="app">
    <ProductCrud />
  </div>
</template>

<script>
import ProductCrud from './components/ProductCrud.vue';

export default {
  name: 'App',
  components: {
    ProductCrud
  }
};
</script>

<style>
/* Adicione seus estilos aqui */
</style>
EOL

echo "Setup concluído com sucesso."
echo "======================================"
echo "Para executar o backend, abra um terminal na raiz do projeto e execute:"
echo "    mvn clean spring-boot:run"
echo "Para executar o frontend, navegue até '$VUE_PROJECT_DIR' e execute:"
echo "    npm run serve"
echo "======================================" 