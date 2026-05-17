import QtQuick
import QtQuick.Layouts
import WaiterLogic 1.0

Item {
    id: orderScreen

    property var theme: null
    property int tableId: 0
    property int orderId: 0

    property var categoriesModel: Waiter.menuGetter

    // Datos crudos de la query: [{id_menu, quantity}, ...]
    property var orderItems: []

    // Convierte el array de la query a mapa {dishId: quantity}
    property var orderQuantities: {
        var map = {}
        for (var i = 0; i < orderItems.length; i++) {
            var item = orderItems[i]
            if (item.id_menu !== undefined && item.quantity > 0) {
                map[item.id_menu] = item.quantity
            }
        }
        return map
    }

    signal requestBack()
    signal requestHelp()
    signal requestEditOrder(int orderId, var orderData)
    signal requestCloseOrder(int orderId, var orderData)

    Connections{
        target: Waiter

        function onOrderGetter(order){
            orderItems = order
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Rectangle {
            Layout.fillWidth: true
            height: 60
            radius: theme.borderRadiusSmall
            color: theme.backgroundSecondary

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                spacing: 2

                Text {
                    text: "Mesa " + tableId
                    font {
                        family: theme.fontFamily
                        pixelSize: theme.fontSizeLarge
                        bold: true
                    }
                    color: theme.textPrimary
                }

                Text {
                    text: "Orden #" + orderId
                    font {
                        family: theme.fontFamily
                        pixelSize: theme.fontSizeSmall
                    }
                    color: theme.textSecondary
                }
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
                    id: categoriesRepeater
                    model: categoriesModel

                    ExpandableCategory {
                        width: parent.width
                        theme: orderScreen.theme
                        categoryName: modelData.name || "Categoría"
                        dishesModel: modelData.dishes || []

                        // Mapa completo; cada categoría filtra sus propios platillos
                        preloadedQuantities: orderScreen.orderQuantities

                        onDishQuantityChanged: function(dishId, newQuantity, dishName) {
                            // Opcional: lógica si necesitas trackear modificaciones
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            height: 50
            spacing: 16

            Item {
                id: actionsContainer
                Layout.fillWidth: true
                height: 50

                property bool expanded: false

                // Botón principal
                Rectangle {
                    anchors.fill: parent
                    radius: theme.borderRadiusSmall
                    color: actionsMouse.containsPress ? theme.buttonSecondaryHover : theme.buttonSecondary

                    Text {
                        anchors.centerIn: parent
                        text: "Pedido"
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontSizeMedium
                            bold: true
                        }
                        color: theme.textPrimary
                    }

                    MouseArea {
                        id: actionsMouse
                        anchors.fill: parent
                        onClicked: actionsContainer.expanded = !actionsContainer.expanded
                    }
                }

                Column {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 8
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 8
                    visible: actionsContainer.expanded
                    opacity: actionsContainer.expanded ? 1 : 0
                    z: 100

                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    // ── Editar Pedido ──
                    Rectangle {
                        width: parent.width
                        height: 45
                        radius: theme.borderRadiusSmall
                        color: editMouse.containsPress ? theme.buttonSecondaryHover : theme.buttonSecondary

                        Text {
                            anchors.centerIn: parent
                            text: "Editar Pedido"
                            font {
                                family: theme.fontFamily
                                pixelSize: theme.fontSizeMedium
                                bold: true
                            }
                            color: theme.textPrimary
                        }

                        MouseArea {
                            id: editMouse
                            anchors.fill: parent
                            onClicked: {
                                var currentOrder = orderScreen.compileOrder()
                                orderScreen.requestEditOrder(orderScreen.orderId, currentOrder)
                                actionsContainer.expanded = false
                            }
                        }
                    }

                    // ── Cerrar Pedido ──
                    Rectangle {
                        width: parent.width
                        height: 45
                        radius: theme.borderRadiusSmall
                        color: closeMouse.containsPress ? theme.buttonSecondaryHover : theme.buttonSecondary

                        Text {
                            anchors.centerIn: parent
                            text: "Cerrar Pedido"
                            font {
                                family: theme.fontFamily
                                pixelSize: theme.fontSizeMedium
                                bold: true
                            }
                            color: theme.textPrimary
                        }

                        MouseArea {
                            id: closeMouse
                            anchors.fill: parent
                            onClicked: {
                                var currentOrder = orderScreen.compileOrder()
                                orderScreen.requestCloseOrder(orderScreen.orderId, currentOrder)
                                actionsContainer.expanded = false
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: theme.borderRadiusSmall
                color: backMouse.containsPress ? theme.buttonPrimaryHover : theme.buttonPrimary

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
                    id: backMouse
                    anchors.fill: parent
                    onClicked: orderScreen.requestBack()
                }
            }
        }
    }

    function compileOrder() {
        var order = []
        for (var i = 0; i < categoriesRepeater.count; i++) {
            var cat = categoriesRepeater.itemAt(i)
            if (cat) {
                order = order.concat(cat.getSelectedItems())
            }
        }
        return order
    }
}
