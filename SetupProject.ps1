<# 
    SetupProject.ps1
    This PowerShell script sets up the full-stack CRUD project by:
      - Verifying that Java (11 or later), Maven, Node.js, npm, and Vue CLI are installed.
      - Automatically installing Vue CLI globally if not found.
      - Creating a new Vue.js project (named "my-vue-app") using the Vue CLI if one doesn't already exist.
      - Copying the provided "frontend\ProductCrud.vue" file into the new Vue project's "src\components" directory.
      - Overwriting "src\App.vue" in the Vue project to include the ProductCrud component.
      
    After running this script, follow the on-screen instructions to start the backend and frontend.
#>

# Function to check for required commands
function Check-Command {
    param(
        [Parameter(Mandatory)]
        [string]$Command,
        [Parameter(Mandatory)]
        [string]$Name
    )
    Write-Host "Checking for $Name..."
    if(-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        Write-Error "$Name is not installed or not available in PATH."
        return $false
    }
    return $true
}

# Check for Java
if (-not (Check-Command "java" "Java")) {
    Write-Error "Please install Java 11 or later and ensure it's added to PATH."
    exit 1
}

# Function to extract the major version from java -version
function Get-JavaVersion {
    $javaVersionOutput = & java -version 2>&1 | Select-String 'version'
    if ($javaVersionOutput -match '"(\d+)\.(\d+).*"') {
        return [int]$Matches[1]
    }
    elseif ($javaVersionOutput -match '"(\d+)"') {
        return [int]$Matches[1]
    }
    else {
        Write-Error "Unable to determine Java version."
        return 0
    }
}

$javaVersion = Get-JavaVersion
if ($javaVersion -lt 11) {
    Write-Error "Java 11 or later is required. Found version $javaVersion."
    exit 1
} else {
    Write-Host "Java version $javaVersion detected."
}

# Check for Maven
if (-not (Check-Command "mvn" "Maven")) {
    Write-Error "Please install Maven and ensure it's added to PATH."
    exit 1
}

# Check for Node.js
if (-not (Check-Command "node" "Node.js")) {
    Write-Error "Please install Node.js."
    exit 1
}

# Check for npm
if (-not (Check-Command "npm" "npm")) {
    Write-Error "Please install npm."
    exit 1
}

# Check for Vue CLI; install if missing
if (-not (Check-Command "vue" "Vue CLI")) {
    Write-Host "Vue CLI not found. Installing Vue CLI globally using npm..."
    npm install -g @vue/cli
    if (-not (Check-Command "vue" "Vue CLI")) {
        Write-Error "Vue CLI installation failed. Please install it manually."
        exit 1
    }
}

Write-Host "All prerequisites are installed."

# --- Frontend Setup ---
# Define the Vue project directory name
$vueProjectDir = "my-vue-app"

# Create the Vue project if it doesn't exist
if (-not (Test-Path $vueProjectDir)) {
    Write-Host "Creating Vue project '$vueProjectDir'..."
    vue create $vueProjectDir --default --packageManager npm
} else {
    Write-Host "Vue project '$vueProjectDir' already exists. Skipping creation."
}

# Copy ProductCrud.vue into the Vue project's components folder
$sourceComponent = "frontend\ProductCrud.vue"
$destDir = Join-Path $vueProjectDir "src\components"
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}
Write-Host "Copying ProductCrud.vue to $destDir..."
Copy-Item $sourceComponent -Destination $destDir -Force

# Overwrite App.vue to integrate the ProductCrud component
$appVuePath = Join-Path $vueProjectDir "src\App.vue"
$appVueContent = @"
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
/* Add your styles here */
</style>
"@
Write-Host "Updating App.vue to integrate the ProductCrud component..."
$appVueContent | Set-Content $appVuePath

Write-Host "`nSetup completed successfully."
Write-Host "======================================"
Write-Host "To run the backend, open a terminal and execute:"
Write-Host "    mvn clean spring-boot:run"
Write-Host "`nTo run the frontend, navigate to '$vueProjectDir' and execute:"
Write-Host "    npm run serve"
Write-Host "======================================" 