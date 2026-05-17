import QtQuick
import QtQuick.Layouts

Rectangle {
    id: expandableCategory

    property var theme: null
    property string categoryName: "Categoría"
    property var dishesModel: []

    // Diccionario interno: { dishId: quantity }
    property var selectedQuantities: ({})
    property var preloadedQuantities: ({})

    signal dishQuantityChanged(int dishId, int newQuantity, string dishName)
    signal categoryExpanded(bool isExpanded)

    property bool isExpanded: false
    property int headerHeight: 50
    property int dishRowHeight: 45

    width: parent ? parent.width : 300
    radius: theme.borderRadiusSmall
    color: isExpanded ? theme.backgroundSecondary : theme.backgroundPrimary
    border { width: 1; color: theme.borderColor || theme.backgroundSecondary }

    height: headerHeight + (isExpanded ? dishesModel.length * dishRowHeight : 0)
    Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

    //Funciones Principales
    function getQuantity(dishId) {
        return selectedQuantities[dishId] || 0
    }

    function setQuantity(dishId, newQty) {
        var dish = null
        for (var i = 0; i < dishesModel.length; i++) {
            if (dishesModel[i].id === dishId) {
                dish = dishesModel[i]
                break
            }
        }
        if (!dish) return

        var newQuantities = {}
        for (var key in selectedQuantities) {
            newQuantities[key] = selectedQuantities[key]
        }

        if (newQty <= 0) {
            delete newQuantities[dishId]
        } else {
            newQuantities[dishId] = newQty
        }

        selectedQuantities = newQuantities
        dishQuantityChanged(dishId, newQty <= 0 ? 0 : newQty, dish.name || "")
    }

    function getSelectedItems() {
        var result = []
        for (var dishId in selectedQuantities) {
            if (selectedQuantities.hasOwnProperty(dishId)) {
                var qty = selectedQuantities[dishId]
                if (qty > 0) {
                    var dish = null
                    for (var i = 0; i < dishesModel.length; i++) {
                        if (dishesModel[i].id === parseInt(dishId)) {
                            dish = dishesModel[i]
                            break
                        }
                    }
                    if (dish) {
                        result.push({
                            dishId: parseInt(dishId),
                            quantity: qty
                        })
                    }
                }
            }
        }
        return result
    }

    function clearSelection() {
        selectedQuantities = ({})
    }

    //Funciones Secundarias
    Component.onCompleted: applyPreloadedQuantities()
    onPreloadedQuantitiesChanged: applyPreloadedQuantities()

    function applyPreloadedQuantities() {
        if (!preloadedQuantities) return
        var newQty = {}
        for (var i = 0; i < dishesModel.length; i++) {
            var dishId = dishesModel[i].id
            if (preloadedQuantities[dishId] !== undefined && preloadedQuantities[dishId] > 0) {
                newQty[dishId] = preloadedQuantities[dishId]
            }
        }
        selectedQuantities = newQty
    }

    // Funciones Privadas (helpers)
    function updateDishQuantity(index, delta) {
        var dish = dishesModel[index]
        var dishId = dish.id
        var currentQty = getQuantity(dishId)
        var newQty = Math.max(0, currentQty + delta)

        setQuantity(dishId, newQty)
    }

    Column {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            width: parent.width
            height: headerHeight
            color: mouseAreaHeader.containsPress
                   ? theme.buttonSecondaryHover
                   : (isExpanded ? theme.buttonSecondary : theme.backgroundPrimary)
            radius: theme.borderRadiusSmall

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                Text {
                    text: categoryName
                    font {
                        family: theme.fontFamily
                        pixelSize: theme.fontSizeMedium
                        bold: true
                    }
                    color: theme.textPrimary
                    Layout.fillWidth: true
                }

                Text {
                    text: isExpanded ? "▲" : "▼"
                    font {
                        family: theme.fontFamily
                        pixelSize: theme.fontSizeMedium
                    }
                    color: theme.textSecondary
                }
            }

            MouseArea {
                id: mouseAreaHeader
                anchors.fill: parent
                onClicked: {
                    isExpanded = !isExpanded
                    categoryExpanded(isExpanded)
                }
            }
        }

        Column {
            width: parent.width
            visible: isExpanded
            opacity: isExpanded ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Repeater {
                model: dishesModel

                Rectangle {
                    width: parent.width
                    height: dishRowHeight
                    color: index % 2 === 0
                           ? theme.backgroundPrimary
                           : (theme.backgroundTertiary || theme.backgroundSecondary)

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 16
                        spacing: 12

                        // Nombre del platillo
                        Text {
                            text: modelData.name || modelData
                            font {
                                family: theme.fontFamily
                                pixelSize: theme.fontSizeSmall
                            }
                            color: theme.textPrimary
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Row {
                            spacing: 8
                            Layout.preferredWidth: 120

                            Rectangle {
                                width: 28
                                height: 28
                                radius: 14
                                color: minusArea.containsPress
                                       ? theme.buttonSecondaryHover
                                       : theme.buttonSecondary

                                Text {
                                    anchors.centerIn: parent
                                    text: "−"
                                    font { pixelSize: 16; bold: true }
                                    color: theme.textSecondary
                                }

                                MouseArea {
                                    id: minusArea
                                    anchors.fill: parent
                                    onClicked: updateDishQuantity(index, -1)
                                }
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: getQuantity(modelData.id)
                                font {
                                    family: theme.fontFamily
                                    pixelSize: theme.fontSizeMedium
                                    bold: true
                                }
                                color: theme.textPrimary
                                width: 30
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Rectangle {
                                width: 28
                                height: 28
                                radius: 14
                                color: plusArea.containsPress
                                       ? theme.buttonPrimaryHover || theme.buttonPrimary
                                       : theme.buttonPrimary

                                Text {
                                    anchors.centerIn: parent
                                    text: "+"
                                    font { pixelSize: 16; bold: true }
                                    color: theme.textOnPrimary || theme.textSecondary
                                }

                                MouseArea {
                                    id: plusArea
                                    anchors.fill: parent
                                    onClicked: updateDishQuantity(index, +1)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
