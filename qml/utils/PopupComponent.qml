import QtQuick
import QtQuick.Layouts
import "../"

Rectangle {
    id: popupRoot

    // === PROPIEDADES CONFIGURABLES ===
    property var theme: null
    property string title: "Título"
    property string message: "Mensaje del popup"
    property bool showCancelButton: true
    property string confirmText: "Aceptar"
    property string cancelText: "Cancelar"

    // === ESTADOS ===
    property bool isOpen: false

    // === FUNCIONES QUE C++ PUEDE LLAMAR ===
    function open() {
        if (isOpen) return  // Evita abrir si ya está abierto
        isOpen = true
        visible = true
        opacityAnimation.restart()
        scaleAnimation.restart()
    }

    function close() {
        if (!isOpen) return  // Evita cerrar si ya está cerrado
        isOpen = false
        opacityAnimationReverse.restart()
        scaleAnimationReverse.restart()
    }

    function onShowPopup(titleText, messageText, showCancel) {
        title = titleText
        message = messageText
        showCancelButton = showCancel
        open()
    }

    // === SEÑALES QUE QML EMITE HACIA C++ ===
    signal confirmed()
    signal cancelled()
    signal closed()

    // === CONFIGURACIÓN VISUAL ===
    anchors.fill: parent
    color: "#80000000"
    visible: false  // Inicia oculto, no depende de isOpen directamente
    opacity: 0

    // Click fuera del popup para cerrar
    MouseArea {
        anchors.fill: parent
        onClicked: {
            popupRoot.close()
            closed()
        }
    }

    // Contenedor del popup
    Rectangle {
        id: popupContainer
        width: Math.min(parent.width * 0.85, 350)
        height: contentLayout.implicitHeight + 40
        anchors.centerIn: parent
        radius: theme ? theme.borderRadiusMedium : 12
        color: theme ? theme.backgroundSecondary : "#16213e"
        border {
            width: 1
            color: theme ? theme.borderDefault : "#e94560"
        }
        scale: 0.8

        ColumnLayout {
            id: contentLayout
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 16

            // Título
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: popupRoot.title
                font {
                    family: theme ? theme.fontFamily : "Roboto"
                    pixelSize: theme ? theme.fontSizeLarge : 20
                    bold: true
                }
                color: theme ? theme.textPrimary : "#e94560"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            // Separador
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#0f3460"
            }

            // Mensaje
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: popupRoot.message
                font {
                    family: theme ? theme.fontFamily : "Roboto"
                    pixelSize: theme ? theme.fontSizeMedium : 16
                }
                color: theme ? theme.textPlaceholder : "#eaeaea"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            // Espaciador
            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 10
            }

            // Botones
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Botón Cancelar
                Rectangle {
                    Layout.fillWidth: true
                    height: 45
                    radius: theme ? theme.borderRadiusSmall : 6
                    color: mouseAreaCancel.containsPress
                        ? (theme ? theme.buttonPrimaryHover : "#6b4c9a")
                        : (theme ? theme.buttonPrimary : "#533483")
                    visible: showCancelButton

                    Text {
                        anchors.centerIn: parent
                        text: cancelText
                        font {
                            family: theme ? theme.fontFamily : "Roboto"
                            pixelSize: theme ? theme.fontSizeMedium : 16
                            bold: true
                        }
                        color: theme ? theme.textSecondary : "#eaeaea"
                    }

                    MouseArea {
                        id: mouseAreaCancel
                        anchors.fill: parent
                        onClicked: {
                            popupRoot.close()
                            cancelled()
                        }
                    }
                }

                // Botón Confirmar
                Rectangle {
                    Layout.fillWidth: true
                    height: 45
                    radius: theme ? theme.borderRadiusSmall : 6
                    color: mouseAreaConfirm.containsPress
                        ? (theme ? theme.buttonPrimaryHover : "#ff6b6b")
                        : (theme ? theme.buttonPrimary : "#e94560")

                    Text {
                        anchors.centerIn: parent
                        text: confirmText
                        font {
                            family: theme ? theme.fontFamily : "Roboto"
                            pixelSize: theme ? theme.fontSizeMedium : 16
                            bold: true
                        }
                        color: theme ? theme.textSecondary : "#eaeaea"
                    }

                    MouseArea {
                        id: mouseAreaConfirm
                        anchors.fill: parent
                        onClicked: {
                            popupRoot.close()
                            confirmed()
                        }
                    }
                }
            }
        }
    }

    // === ANIMACIONES ===
    // Usamos restart() en lugar de start() para reiniciar siempre

    NumberAnimation {
        id: opacityAnimation
        target: popupRoot
        property: "opacity"
        from: 0
        to: 1
        duration: 200
        easing.type: Easing.OutQuad
    }

    NumberAnimation {
        id: opacityAnimationReverse
        target: popupRoot
        property: "opacity"
        from: 1
        to: 0
        duration: 150
        easing.type: Easing.InQuad
        onFinished: popupRoot.visible = false
    }

    NumberAnimation {
        id: scaleAnimation
        target: popupContainer
        property: "scale"
        from: 0.8
        to: 1
        duration: 200
        easing.type: Easing.OutBack
    }

    NumberAnimation {
        id: scaleAnimationReverse
        target: popupContainer
        property: "scale"
        from: 1
        to: 0.8
        duration: 150
        easing.type: Easing.InQuad
    }
}
