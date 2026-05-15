import QtQuick
import QtQuick.Controls
import "tables"
import AppWindowLogic 1.0

ApplicationWindow {
    id: window
    visible: true
        width: 400
        height: 700
        title: "Restaurant App"
        color: theme.backgroundPrimary

        Theme { id: theme }

        property int currentScreen: AppWindow.currentScreen

        LoginScreen {
            id: loginScreen
            anchors.fill: parent
            visible: currentScreen === 0
            theme: theme
            onLoginSuccess: AppWindow.goToTables()
        }

        TablesScreen {
            id: tablesScreen
            anchors.fill: parent
            visible: currentScreen === 1
            theme: theme
        }
}
