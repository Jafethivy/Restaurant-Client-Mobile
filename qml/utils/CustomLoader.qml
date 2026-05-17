import QtQuick

Loader {
    id: root

    signal screenReady(var item)

    onStatusChanged: {
        if (status === Loader.Ready && item !== null) {
            root.screenReady(item)
        }
    }

    Component.onCompleted: {
        if (status === Loader.Ready && item !== null) {
            root.screenReady(item)
        }
    }
}
