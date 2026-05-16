import QtQuick

Rectangle {
    id: tableItem

    // Propiedades que C++ setea vía bindings
    property int tableId: 0
    property int tableStatus: 0
    property bool hasOrder: false   // true = orden activa, false = sin ordenes
    property string tableName: "Mesa " + tableId
    property var extraData: null
    property var theme: null
    width: 150
    height: 120
    radius: theme.borderRadiusSmall

    color: tableStatus === 2 ? theme.tableAvailable : theme.tableDisabled

    border { width: 2; color: theme.backgroundPrimary }

    Column {
        anchors.fill: parent
        anchors.topMargin: 6
        anchors.bottomMargin: 6
        spacing: 4

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 16
            height: tableStatus === 2 ? 22 : 0
            radius: theme.borderRadiusSmall

            // Ámbar = orden activa | Gris pizarra = sin orden
            color: hasOrder ? "#F59E0B" : "#64748B"
            Behavior on color { ColorAnimation { duration: 200 } }

            Text {
                anchors.centerIn: parent
                text: hasOrder ? "ORDEN" : "SIN ORDEN"
                font { family: theme.fontFamily; pixelSize: 10; bold: true }
                color: "white"
            }
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: tableId
                font { family: theme.fontFamily; pixelSize: theme.fontSizeLarge; bold: true }
                color: {
                    switch(tableStatus) {
                        case 2: return theme.textPrimary
                        default: return theme.textPlaceholder
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: tableName
                font { family: theme.fontFamily; pixelSize: theme.fontSizeSmall }
                color: tableStatus === 2 ? theme.textPrimary : theme.textPlaceholder
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    switch(tableStatus) {
                        case 2: return "Atender"
                        default: return "Deshabilitada"
                    }
                }
                font { family: theme.fontFamily; pixelSize: theme.fontSizeSmall }
                color: tableStatus === 2 ? theme.textPrimary : theme.textPlaceholder
            }
        }
    }

    scale: mouseAreaTable.containsPress ? 0.95 : 1.0
    Behavior on scale { NumberAnimation { duration: 100 } }
    Behavior on color { ColorAnimation { duration: 200 } }

    MouseArea {
        id: mouseAreaTable
        anchors.fill: parent
        enabled: tableStatus === 2
        onClicked: if(!hasOrder){
            tableSelected(tableId, tableStatus)
        }else{
            console.log("asdadasda")
        }
    }

    signal tableSelected(int id, int status)
}
