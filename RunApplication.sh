#!/bin/bash
# RunApplication.sh
# Este script executa o backend e o frontend da aplicação.
# Ele inicia o Spring Boot (backend) em segundo plano e, após aguardar seu início,
# muda para o diretório do projeto Vue para iniciar o frontend.

# Verifica se Maven está instalado
command -v mvn >/dev/null 2>&1 || { echo "Maven não está instalado."; exit 1; }

echo "Iniciando o backend..."
mvn clean spring-boot:run &
BACKEND_PID=$!

# Aguarda alguns segundos para o backend iniciar (ajuste se necessário)
echo "Aguardando o backend iniciar (aguarde 10 segundos)..."
sleep 10

VUE_PROJECT_DIR="my-vue-app"

if [ ! -d "$VUE_PROJECT_DIR" ]; then
    echo "Diretório '$VUE_PROJECT_DIR' não encontrado. Por favor, execute SetupProject.sh primeiro."
    kill $BACKEND_PID
    exit 1
fi

echo "Iniciando o frontend..."
cd "$VUE_PROJECT_DIR" || exit 1
npm run serve

# Obs: Neste script, o processo do backend continuará em segundo plano.
# Se desejar finalizá-lo, utilize o comando 'kill' com o PID $BACKEND_PID. 