import QtQuick

QtObject {
    // Colores de fondo
    readonly property color backgroundPrimary: "#1a1a2e"
    readonly property color backgroundSecondary: "#778EBB"
    readonly property color backgroundThird: "#A48465"

    // Colores de texto
    readonly property color textPrimary: "#DDDBF1"
    readonly property color textSecondary: "#6F7B9B"
    readonly property color textPlaceholder: "#323848"

    // Colores de mesas
    readonly property color tableDisabled: "#808080"   // gris = deshabilitada
    readonly property color tableAvailable: "#00c853"  // verde = disponible
    readonly property color tableOccupied: "#ff5252"   // rojo = ocupada (para futuro)
    readonly property color tableReserved: "#ffd740"   // amarillo = reservada (para futuro)

    // Colores de botones
    readonly property color buttonPrimary: "#4B6495"
    readonly property color buttonPrimaryHover: "#778EBB"
    readonly property color buttonSecondary: "#827BCC"
    readonly property color buttonSecondaryHover: "#9D98D7"

    // Colores de bordes
    readonly property color borderDefault: "#37496D"
    readonly property color borderFocused: "#5C77AD"

    // Tamaños
    readonly property int borderRadiusSmall: 6
    readonly property int borderRadiusMedium: 12
    readonly property int borderRadiusLarge: 20

    // Fuentes
    readonly property string fontFamily: "Roboto"
    readonly property int fontSizeSmall: 12
    readonly property int fontSizeMedium: 18
    readonly property int fontSizeLarge: 20
    readonly property int fontSizeTitle: 36
}
