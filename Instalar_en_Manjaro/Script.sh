#!/bin/bash

# ============================================
# SCRIPT DE CONFIGURACIÓN DE GO PARA MANJARO
# ============================================

set -e  # Detener ejecución si hay error

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================
# 1. ACTUALIZAR SISTEMA
# ============================================
print_info "Actualizando sistema..."
sudo pacman -Syu --noconfirm

# ============================================
# 2. INSTALAR GO
# ============================================
print_info "Instalando Go..."
if command_exists go; then
    print_warning "Go ya está instalado. Versión actual:"
    go version
else
    sudo pacman -S go --noconfirm
    if command_exists go; then
        print_success "Go instalado correctamente"
        go version
    else
        print_error "Error instalando Go"
        exit 1
    fi
fi

# ============================================
# 3. CONFIGURAR VARIABLES DE ENTORNO
# ============================================
print_info "Configurando variables de entorno..."

# Detectar shell actual
SHELL_CONFIG=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    # Intentar detectar config file
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    else
        SHELL_CONFIG="$HOME/.bashrc"
        touch "$SHELL_CONFIG"
    fi
fi

print_info "Usando archivo de configuración: $SHELL_CONFIG"

# Configuración para Go
GO_CONFIG="# ===== CONFIGURACIÓN GO =====
export GOPATH=\$HOME/go
export GOBIN=\$GOPATH/bin
export PATH=\$PATH:/usr/local/go/bin:\$GOBIN
export GO111MODULE=on
# ================================="

# Verificar si la configuración ya existe
if grep -q "CONFIGURACIÓN GO" "$SHELL_CONFIG"; then
    print_warning "La configuración de Go ya existe en $SHELL_CONFIG"
else
    # Backup del archivo original
    cp "$SHELL_CONFIG" "${SHELL_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Añadir configuración
    echo -e "\n$GO_CONFIG" >> "$SHELL_CONFIG"
    print_success "Configuración añadida a $SHELL_CONFIG"
fi

# ============================================
# 4. CREAR ESTRUCTURA DE DIRECTORIOS
# ============================================
print_info "Creando estructura de directorios de Go..."

# Directorios esenciales
DIRECTORIES=(
    "$HOME/go"
    "$HOME/go/src"
    "$HOME/go/bin"
    "$HOME/go/pkg"
    "$HOME/go/src/ejemplos"
    "$HOME/go/src/proyectos"
)

for dir in "${DIRECTORIES[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_info "  Creado: $dir"
    else
        print_warning "  Ya existe: $dir"
    fi
done

# ============================================
# 5. INSTALAR HERRAMIENTAS BÁSICAS DE GO
# ============================================
print_info "Instalando herramientas básicas de Go..."

# Aplicar variables de entorno temporalmente
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin:/usr/local/go/bin
export GO111MODULE=on

# Lista de herramientas recomendadas
GO_TOOLS=(
    "golang.org/x/tools/gopls@latest"           # Servidor de lenguaje
    "github.com/go-delve/delve/cmd/dlv@latest"  # Debugger
    "honnef.co/go/tools/cmd/staticcheck@latest" # Linter avanzado
    "golang.org/x/tools/cmd/goimports@latest"   # Formateo de imports
    "github.com/ramya-rao-a/go-outline@latest"  # Outline para VS Code
    "github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest"
    "github.com/cweill/gotests/gotests@latest"  # Generador de tests
)

for tool in "${GO_TOOLS[@]}"; do
    tool_name=$(echo "$tool" | awk -F'/' '{print $NF}' | awk -F'@' '{print $1}')
    print_info "Instalando: $tool_name"
    
    if go install "$tool" 2>/dev/null; then
        print_success "  ✓ $tool_name instalado"
    else
        print_warning "  ✗ Error instalando $tool_name, intentando con módulos..."
        GO111MODULE=on go get "$tool"
    fi
done

# ============================================
# 6. CREAR ARCHIVO DE PRUEBA
# ============================================
print_info "Creando archivo de prueba..."

TEST_FILE="$HOME/go/src/ejemplos/hola_mundo.go"

cat > "$TEST_FILE" << 'EOF'
package main

import (
    "fmt"
    "runtime"
)

func main() {
    fmt.Println("¡Hola desde Manjaro!")
    fmt.Printf("Sistema operativo: %s\n", runtime.GOOS)
    fmt.Printf("Arquitectura: %s\n", runtime.GOARCH)
    fmt.Printf("Versión de Go: %s\n", runtime.Version())
    
    // Ejemplo adicional
    nombres := []string{"Alice", "Bob", "Charlie"}
    fmt.Println("\nNombres:")
    for i, nombre := range nombres {
        fmt.Printf("  %d. %s\n", i+1, nombre)
    }
}
EOF

print_success "Archivo creado: $TEST_FILE"

# ============================================
# 7. VERIFICAR INSTALACIÓN
# ============================================
print_info "Verificando instalación..."

echo ""
echo "========================================="
echo "VERIFICACIÓN DE INSTALACIÓN"
echo "========================================="

# Verificar Go
if command_exists go; then
    print_success "✓ Go está instalado"
    echo "  Versión: $(go version)"
    echo "  GOPATH: $GOPATH"
    echo "  GOROOT: $(go env GOROOT)"
else
    print_error "✗ Go NO está instalado"
fi

# Verificar herramientas
print_info "\nHerramientas instaladas:"
if command_exists gopls; then
    print_success "  ✓ gopls (servidor de lenguaje)"
fi
if command_exists dlv; then
    print_success "  ✓ dlv (debugger)"
fi
if command_exists staticcheck; then
    print_success "  ✓ staticcheck (linter)"
fi
if command_exists goimports; then
    print_success "  ✓ goimports (formateador)"
fi

# Probar compilación
print_info "\nProbando compilación..."
cd "$HOME/go/src/ejemplos"

if go build hola_mundo.go; then
    print_success "✓ Compilación exitosa"
    
    print_info "Ejecutando programa..."
    echo "-----------------------------------------"
    ./hola_mundo
    echo "-----------------------------------------"
    
    # Limpiar
    rm -f hola_mundo
else
    print_error "✗ Error en la compilación"
    exit 1
fi

# ============================================
# 8. CONFIGURACIÓN PARA VS CODE (OPCIONAL)
# ============================================
print_info "\nConfiguración recomendada para VS Code:"

cat << 'EOF'

=========================================
PASOS MANUALES PARA VS CODE:
=========================================

1. Abre VS Code
2. Instala la extensión "Go" de Microsoft
3. Abre cualquier archivo .go
4. VS Code te pedirá instalar herramientas adicionales
   - Acepta todas las instalaciones
5. Configuración recomendada en settings.json:
   
   {
     "go.useLanguageServer": true,
     "go.languageServerFlags": ["-rpc.trace"],
     "go.formatTool": "goimports",
     "go.lintTool": "staticcheck",
     "go.autocompleteUnimportedPackages": true,
     "go.gocodePackageLookupMode": "go",
     "go.gotoSymbol.includeImports": true,
     "go.useCodeSnippetsOnFunctionSuggest": true,
     "go.docsTool": "gogetdoc",
     "[go]": {
         "editor.formatOnSave": true,
         "editor.codeActionsOnSave": {
             "source.organizeImports": true
         }
     }
   }
EOF

# ============================================
# 9. INSTRUCCIONES FINALES
# ============================================
cat << 'EOF'

=========================================
¡INSTALACIÓN COMPLETADA!
=========================================

RECUERDA:

1. Cierra y reabre tu terminal o ejecuta:
   source $SHELL_CONFIG

2. Para probar que todo funciona:
   cd ~/go/src/ejemplos
   go run hola_mundo.go

3. Comandos útiles:
   - go run archivo.go    # Ejecutar
   - go build archivo.go  # Compilar
   - go fmt ./...         # Formatear
   - go test ./...        # Ejecutar tests
   - go mod init nombre   # Iniciar módulo

4. Recursos para aprender:
   - Tour de Go: https://tour.golang.org
   - Documentación oficial: https://golang.org/doc
   - Go by Example: https://gobyexample.com

Tu workspace está en: ~/go/
Ejemplos en: ~/go/src/ejemplos/
Proyectos en: ~/go/src/proyectos/
EOF

print_success "\n¡Configuración completada exitosamente!"
