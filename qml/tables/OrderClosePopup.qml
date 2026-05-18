import QtQuick
import QtQuick.Layouts
import "../"

Rectangle {
    id: popupRoot

    property var theme: null
    property int orderId: 0
    property double totalAmount: 0.0

    // Señales hacia el padre
    signal confirmed()
    signal cancelled()

    anchors.fill: parent
    color: "#80000000"
    visible: false
    opacity: 0

    function open(popupOrderId, total) {
        orderId = popupOrderId
        totalAmount = total
        visible = true
        fadeIn.start()
        scaleIn.start()
    }

    function close() {
        fadeOut.start()
        scaleOut.start()
    }

    // Cerrar al tocar fuera
    MouseArea {
        anchors.fill: parent
        onClicked: {
            close()
            cancelled()
        }
    }

    // Card central
    Rectangle {
        id: card
        width: Math.min(parent.width * 0.85, 380)
        height: contentLayout.implicitHeight + 48
        anchors.centerIn: parent
        radius: theme ? theme.borderRadiusMedium : 12
        color: theme ? theme.backgroundSecondary : "#16213e"
        border {
            width: 1
            color: theme ? theme.borderDefault || theme.backgroundSecondary : "#0f3460"
        }
        scale: 0.8

        ColumnLayout {
            id: contentLayout
            anchors {
                fill: parent
                margins: 24
            }
            spacing: 20

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Confirmar Cierre"
                font {
                    family: theme ? theme.fontFamily : "Roboto"
                    pixelSize: theme ? theme.fontSizeLarge : 20
                    bold: true
                }
                color: theme ? theme.textPrimary : "#e94560"
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme ? theme.backgroundPrimary || "#0f3460" : "#0f3460"
                opacity: 0.5
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Orden #" + orderId
                font {
                    family: theme ? theme.fontFamily : "Roboto"
                    pixelSize: theme ? theme.fontSizeMedium : 16
                }
                color: theme ? theme.textPlaceholder || theme.textSecondary : "#eaeaea"
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "$ " + totalAmount.toFixed(2)
                font {
                    family: theme ? theme.fontFamily : "Roboto"
                    pixelSize: theme ? theme.fontSizeLarge + 4 : 28
                    bold: true
                }
                color: theme ? theme.textPrimary : "#ffffff"
            }

            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 8
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: theme ? theme.borderRadiusSmall : 6
                    color: confirmMouse.containsPress ? theme.buttonSecondaryHover : theme.buttonSecondary

                    Text {
                        anchors.centerIn: parent
                        text: "Cerrar Pedido"
                        font {
                            family: theme ? theme.fontFamily : "Roboto"
                            pixelSize: theme ? theme.fontSizeMedium : 16
                            bold: true
                        }
                        color: theme.textPrimary
                    }

                    MouseArea {
                        id: confirmMouse
                        anchors.fill: parent
                        onClicked: {
                            popupRoot.close()
                            confirmed()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: theme ? theme.borderRadiusSmall : 6
                    color: cancelMouse.containsPress ? theme.buttonPrimaryHover : theme.buttonPrimary

                    Text {
                        anchors.centerIn: parent
                        text: "Cancelar"
                        font {
                            family: theme ? theme.fontFamily : "Roboto"
                            pixelSize: theme ? theme.fontSizeMedium : 16
                            bold: true
                        }
                        color: theme.textPrimary
                    }

                    MouseArea {
                        id: cancelMouse
                        anchors.fill: parent
                        onClicked: {
                            popupRoot.close()
                            cancelled()
                        }
                    }
                }
            }
        }
    }

    // Animaciones
    NumberAnimation {
        id: fadeIn
        target: popupRoot
        property: "opacity"
        from: 0
        to: 1
        duration: 180
        easing.type: Easing.OutQuad
    }

    NumberAnimation {
        id: fadeOut
        target: popupRoot
        property: "opacity"
        from: 1
        to: 0
        duration: 150
        easing.type: Easing.InQuad
        onFinished: popupRoot.visible = false
    }

    NumberAnimation {
        id: scaleIn
        target: card
        property: "scale"
        from: 0.8
        to: 1
        duration: 200
        easing.type: Easing.OutBack
    }

    NumberAnimation {
        id: scaleOut
        target: card
        property: "scale"
        from: 1
        to: 0.85
        duration: 150
        easing.type: Easing.InQuad
    }
}
