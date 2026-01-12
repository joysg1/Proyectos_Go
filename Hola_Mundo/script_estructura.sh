#!/bin/bash

# Script para crear proyecto GUI en Go con Fyne en Manjaro
echo "========================================="
echo "  CREANDO PROYECTO GUI EN GO PARA MANJARO"
echo "========================================="

# 1. Crear directorio del proyecto
PROYECTO="hola-gui"
mkdir -p ~/$PROYECTO
cd ~/$PROYECTO

echo "[✓] Directorio creado: ~/$PROYECTO"

# 2. Crear archivo go.mod
cat > go.mod << 'MOD_EOF'
module holagui

go 1.21
MOD_EOF

echo "[✓] Archivo go.mod creado"

# 3. Crear archivo main.go con interfaz gráfica completa
cat > main.go << 'MAIN_EOF'
package main

import (
    "fyne.io/fyne/v2/app"
    "fyne.io/fyne/v2/container"
    "fyne.io/fyne/v2/widget"
    "fyne.io/fyne/v2/dialog"
    "fyne.io/fyne/v2/theme"
    "fyne.io/fyne/v2"
    "strings"
)

func main() {
    // Crear aplicación
    myApp := app.New()
    myWindow := myApp.NewWindow("Go GUI en Manjaro")
    myWindow.Resize(fyne.NewSize(600, 450))

    // Variables
    contador := 0
    textoIngresado := ""

    // Componentes de la interfaz
    titulo := widget.NewLabel("🚀 Aplicación GUI con Go y Fyne")
    titulo.TextStyle = fyne.TextStyle{Bold: true}
    titulo.Alignment = fyne.TextAlignCenter

    labelContador := widget.NewLabel("Contador: 0")
    labelContador.Alignment = fyne.TextAlignCenter

    // Campo de entrada
    entrada := widget.NewEntry()
    entrada.SetPlaceHolder("Escribe algo aquí...")
    entrada.OnChanged = func(texto string) {
        textoIngresado = texto
    }

    // Botones
    botonContador := widget.NewButton("➕ Incrementar", func() {
        contador++
        if contador <= 10 {
            labelContador.SetText("Contador: " + strings.Repeat("⭐", contador))
        } else {
            labelContador.SetText("Contador: " + string(contador) + " (¡Muchas estrellas!)")
        }
    })

    botonMostrar := widget.NewButton("👁️ Mostrar Texto", func() {
        if textoIngresado == "" {
            dialog.ShowInformation("Info", "No has escrito nada aún.", myWindow)
        } else {
            dialog.ShowInformation("Texto ingresado", 
                "Escribiste:\n\n\"" + textoIngresado + "\"", myWindow)
        }
    })

    botonLimpiar := widget.NewButton("🧹 Limpiar", func() {
        entrada.SetText("")
        contador = 0
        textoIngresado = ""
        labelContador.SetText("Contador: 0")
    })

    botonSalir := widget.NewButton("❌ Salir", func() {
        myApp.Quit()
    })

    // Checkbox para tema
    checkboxTema := widget.NewCheck("Tema Oscuro", func(oscuro bool) {
        if oscuro {
            myApp.Settings().SetTheme(theme.DarkTheme())
        } else {
            myApp.Settings().SetTheme(theme.LightTheme())
        }
    })
    checkboxTema.SetChecked(true)

    // Separador
    separador := widget.NewSeparator()

    // Información del sistema
    info := widget.NewLabel("Sistema: Manjaro Linux\nLenguaje: Go 1.21+\nGUI: Fyne v2")
    info.Alignment = fyne.TextAlignCenter

    // Crear layout
    contenido := container.NewVBox(
        titulo,
        separador,
        container.NewHBox(
            widget.NewLabel(""),
        ),
        labelContador,
        container.NewCenter(
            container.NewHBox(
                botonContador,
                botonLimpiar,
            ),
        ),
        container.NewHBox(
            widget.NewLabel(""),
        ),
        widget.NewLabel("Entrada de texto:"),
        entrada,
        container.NewCenter(
            container.NewHBox(
                botonMostrar,
            ),
        ),
        container.NewHBox(
            widget.NewLabel(""),
        ),
        checkboxTema,
        container.NewHBox(
            widget.NewLabel(""),
        ),
        info,
        container.NewHBox(
            widget.NewLabel(""),
        ),
        container.NewCenter(
            botonSalir,
        ),
    )

    myWindow.SetContent(contenido)
    myWindow.ShowAndRun()
}
MAIN_EOF

echo "[✓] Archivo main.go creado"

# 4. Crear README.md
cat > README.md << 'README_EOF'
# Aplicación GUI en Go para Manjaro

## Descripción
Aplicación de ejemplo con interfaz gráfica creada en Go usando Fyne.

## Características
- Contador con visualización gráfica
- Campo de entrada de texto
- Cambio de tema (oscuro/claro)
- Botones interactivos
- Diseño responsive

## Requisitos
- Go 1.21+
- Fyne v2
- GLFW (para gráficos)

## Instalación en Manjaro
\`\`\`bash
# Dependencias del sistema
sudo pacman -S glfw-wayland gcc pkg-config mesa

# Instalar módulos Go
go mod tidy
\`\`\`

## Ejecución
\`\`\`bash
go run main.go
\`\`\`

## Compilar
\`\`\`bash
go build -o mi-app-gui
./mi-app-gui
\`\`\`

## Capturas
- Interfaz con tema oscuro
- Botones interactivos
- Diálogos modales

## Autor
Creado con ❤️ para Manjaro Linux
README_EOF

echo "[✓] Archivo README.md creado"

# 5. Crear script de instalación de dependencias
cat > instalar_dependencias.sh << 'INSTALL_EOF'
#!/bin/bash
echo "Instalando dependencias para Manjaro..."
sudo pacman -S --needed glfw-wayland gcc pkg-config mesa
echo "¡Dependencias instaladas!"
INSTALL_EOF

chmod +x instalar_dependencias.sh

# 6. Inicializar módulo Go y descargar dependencias
echo "[i] Descargando dependencias de Fyne..."
go mod tidy

if [ $? -eq 0 ]; then
    echo "[✓] Dependencias descargadas correctamente"
else
    echo "[!] Error descargando dependencias. Instala manualmente:"
    echo "    go get fyne.io/fyne/v2"
fi

echo ""
echo "========================================="
echo "        PROYECTO CREADO CON ÉXITO"
echo "========================================="
echo ""
echo "📁 Estructura creada en: ~/$PROYECTO"
echo ""
echo "📋 Archivos creados:"
ls -la
echo ""
echo "🚀 Para ejecutar la aplicación:"
echo "   cd ~/$PROYECTO"
echo "   go run main.go"
echo ""
echo "🔧 Para instalar dependencias del sistema:"
echo "   ./instalar_dependencias.sh"
echo ""
echo "⚡ Solucionar problemas GLFW:"
echo "   export FYNE_FBPM=wayland  # Para Wayland"
echo "   # o"
echo "   export FYNE_FBPM=x11       # Para X11"
echo ""
echo "📦 Para compilar:"
echo "   go build -o app-gui"
echo ""
echo "¡Listo! 🎉 Ahora tienes una aplicación GUI en Go para Manjaro."
