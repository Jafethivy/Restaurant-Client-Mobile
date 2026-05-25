import QtQuick
import QtQuick.Layouts
import WaiterLogic 1.0
import "../"
import "../utils"

Item {
    id: tablesScreen

    property var theme: null

    property var tablesModel: []

    property int currentTableId: 0
    property bool menuVisible: false

    property int currentOrderId: 0
    property bool orderVisible: false

    function onTablesLoaded(tablesData) {
        tablesModel = tablesData
    }

    function onTableOrderStatus(tableId, hasOrder, orderId){
        var newModel = [...tablesModel]
        if (newModel[tableId - 1]){
            if(!hasOrder) {newModel[tableId-1].tableStatus = 0}
            newModel[tableId - 1].order = hasOrder
            newModel[tableId - 1].idOrder = orderId
        }
        tablesModel = newModel
    }

    function onTableStatusChanged(tableId, status) {
        var newModel = [...tablesModel]
        if (newModel[tableId - 1]){
            newModel[tableId - 1].status = status
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

    function requestTable(tableId, status) {
        if (status === 2) {
            currentTableId = tableId
            menuVisible = true
        }
    }

    function requestOrder(tableId, orderId) {
        currentTableId = tableId
        currentOrderId = orderId
        menuVisible = false
        orderVisible = true
    }

    Connections{
        target: Waiter

        function onTablesGetter(tables){
            onTablesLoaded(tables)
        }
        function onChangeTableStatus(tableId, hasOrder, orderId){
            onTableOrderStatus(tableId, hasOrder, orderId)
        }
        function onChangeTableCompleted(tableId, hasOrder, orderId){
            onTableOrderStatus(tableId, hasOrder, orderId)
        }
        function onWsChangeTableStatus(tableId, status){
            onTableStatusChanged(tableId, status)
        }
    }

    ColumnLayout {
        id: tablesLayout
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        visible: !tablesScreen.menuVisible && !tablesScreen.orderVisible

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
                        tableId: modelData.tableId
                        tableStatus: modelData.status
                        hasOrder: modelData.order
                        orderId: modelData.idOrder
                        tableName: modelData.name || ("Mesa " + modelData.tableId)
                        extraData: modelData.extra || null
                        theme: tablesScreen.theme
                        width: (grid.width - grid.spacing) / 2

                        onTableSelected: function(tableId, status) {
                            requestTable(tableId, status)
                        }
                        onOrderSelected: function(tableId, orderId){
                            requestOrder(tableId, orderId)
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

    CustomLoader {
        id: orderScreenLoader
        anchors.fill: parent
        active: tablesScreen.orderVisible
        onScreenReady:{
            Waiter.getOrder(currentOrderId)
        }
        sourceComponent: OrderScreen {
            theme: tablesScreen.theme
            tableId: tablesScreen.currentTableId
            orderId: tablesScreen.currentOrderId

            onRequestBack: tablesScreen.orderVisible = false
            onRequestCloseOrder: function(orderId, orderData) {
                orderScreenLoader.active = false
            }
        }
    }
}
