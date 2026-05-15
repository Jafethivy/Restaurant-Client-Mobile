import QtQuick
import QtQuick.Layouts
import WaiterLogic 1.0

Item {
    id: tableMenuScreen

    // Propiedades de entrada
    property var theme: null
    property int tableId: 0

    property var categoriesModel: Waiter.menuGetter

    signal requestBack()
    signal requestHelp()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Rectangle {
            Layout.fillWidth: true
            height: 60
            radius: theme.borderRadiusSmall
            color: theme.backgroundThird

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 20
                }
                text: "Mesa " + tableId
                font {
                    family: theme.fontFamily
                    pixelSize: theme.fontSizeLarge
                    bold: true
                }
                color: theme.textPlaceholder
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: categoriesColumn.height
            clip: true

            Column {
                id: categoriesColumn
                width: parent.width
                spacing: 12

                Repeater {
                    model: categoriesModel

                    ExpandableCategory {
                        width: parent.width
                        theme: tableMenuScreen.theme
                        categoryName: modelData.name || "Categoría"
                        dishesModel: modelData.dishes || []
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            height: 50
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: theme.borderRadiusSmall
                color: mouseAreaHelp.containsPress ? theme.buttonSecondaryHover : theme.buttonSecondary

                Text {
                    anchors.centerIn: parent
                    text: "Completar Orden"
                    font {
                        family: theme.fontFamily
                        pixelSize: theme.fontSizeMedium
                        bold: true
                    }
                    color: theme.textPrimary
                }

                MouseArea {
                    id: mouseAreaHelp
                    anchors.fill: parent
                    onClicked: test
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: theme.borderRadiusSmall
                color: mouseAreaLogout.containsPress ? theme.buttonPrimaryHover : theme.buttonPrimary

                Text {
                    anchors.centerIn: parent
                    text: "Volver"
                    font {
                        family: theme.fontFamily
                        pixelSize: theme.fontSizeMedium
                        bold: true
                    }
                    color: theme.textPrimary
                }

                MouseArea {
                    id: mouseAreaLogout
                    anchors.fill: parent
                    onClicked: requestBack()
                }
            }
        }
    }
}
