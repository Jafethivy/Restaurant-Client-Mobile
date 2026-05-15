import QtQuick
import QtQuick.Layouts
import WaiterLogic 1.0
import "../"

Item {
    id: tablesScreen

    property var theme: null

    property var tablesModel: []

    property int currentTableId: 0
    property bool menuVisible: false

    function onTablesLoaded(tablesData) {
        tablesModel = tablesData
    }

    function onTableStatusChanged(tableId, status, extraData) {
        var newModel = [...tablesModel]
        for (var i = 0; i < newModel.length; i++) {
            if (newModel[i].id === tableId) {
                newModel[i].status = status
                if (extraData) newModel[i].extra = extraData
                break
            }
        }
        tablesModel = newModel
    }

    function onTablePropertyChanged(tableId, propertyName, value) {
        var newModel = [...tablesModel]
        for (var i = 0; i < newModel.length; i++) {
            if (newModel[i].id === tableId) {
                newModel[i][propertyName] = value
                break
            }
        }
        tablesModel = newModel
    }


    function requestTable(id, status) {
        if (status === 2) {
            currentTableId = id
            menuVisible = true
        }
    }

    Connections{
        target: Waiter

        function onTablesGetter(tables){
            onTablesLoaded(tables)
        }
    }

    ColumnLayout {
        id: tablesLayout
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        visible: !tablesScreen.menuVisible

        Rectangle {
            Layout.fillWidth: true
            height: 60
            radius: theme.borderRadiusSmall
            color: theme.backgroundThird

            Text {
                anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 20 }
                text: "Seleccione una Mesa"
                font { family: theme.fontFamily; pixelSize: theme.fontSizeLarge; bold: true }
                color: theme.textPlaceholder
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: grid.height
            clip: true

            Grid {
                id: grid
                width: parent.width
                columns: 2
                spacing: 16

                Repeater {
                    model: tablesModel

                    TableItem {
                        tableId: modelData.idTable
                        tableStatus: modelData.status
                        tableName: modelData.name || ("Mesa " + modelData.idTable)
                        extraData: modelData.extra || null
                        hasOrder: modelData.order === 1
                        theme: tablesScreen.theme
                        width: (grid.width - grid.spacing) / 2

                        onTableSelected: function(id, status) {
                            if (status === 2) {
                                requestTable(id, status)
                            }
                        }
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
                    text: "Ayuda"
                    font { family: theme.fontFamily; pixelSize: theme.fontSizeMedium; bold: true }
                    color: theme.textPrimary
                }

                MouseArea {
                    id: mouseAreaHelp
                    anchors.fill: parent
                    onClicked: requestHelp()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: theme.borderRadiusSmall
                color: mouseAreaLogout.containsPress ? theme.buttonPrimaryHover : theme.buttonPrimary

                Text {
                    anchors.centerIn: parent
                    text: "Cerrar Sesión"
                    font { family: theme.fontFamily; pixelSize: theme.fontSizeMedium; bold: true }
                    color: theme.textPrimary
                }

                MouseArea {
                    id: mouseAreaLogout
                    anchors.fill: parent
                    onClicked: Waiter.logout()
                }
            }
        }
    }

    Loader {
        id: menuLoader
        anchors.fill: parent
        active: tablesScreen.menuVisible
        sourceComponent: MenuScreen {
            theme: tablesScreen.theme
            tableId: tablesScreen.currentTableId

            onRequestBack: tablesScreen.menuVisible = false
            onRequestHelp: requestHelp()
        }
    }
}
