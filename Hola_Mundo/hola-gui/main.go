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
