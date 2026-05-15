import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import LoginLogic 1.0
import "utils"

Item {
    id: loginScreen

    property var theme: null

    // === ESTADOS INTERNOS ===
    property bool isLoading: false
    property string errorMessage: ""

    signal loginSuccess()

    function loginError(){
        errorPopup.open()
    }

    Connections{
        target: Login

        function onLoginSuccess(){
            loginSuccess()
            loginScreen.isLoading = false
        }
        function onLoginError(){
            loginError()
            loginScreen.isLoading = false
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 400)
        spacing: 20

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Bienvenido"
            font { family: theme.fontFamily; pixelSize: theme.fontSizeTitle; bold: true }
            color: theme.textPrimary
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Ingrese sus credenciales"
            font { family: theme.fontFamily; pixelSize: theme.fontSizeMedium }
            color: theme.textSecondary
        }

        Rectangle {
            Layout.fillWidth: true
            height: 70
            radius: theme.borderRadiusSmall
            color: theme.backgroundSecondary
            border { width: idField.activeFocus ? 2 : 1; color: idField.activeFocus ? theme.borderFocused : theme.borderDefault }

            TextField {
                id: idField
                anchors { fill: parent; margins: 10 }
                placeholderText: "ID de usuario"
                placeholderTextColor: theme.textPlaceholder
                color: theme.textPrimary
                font { family: theme.fontFamily; pixelSize: theme.fontSizeMedium }
                background: null
                inputMethodHints: Qt.ImhDigitsOnly
                maximumLength: 20
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 70
            radius: theme.borderRadiusSmall
            color: theme.backgroundSecondary
            border { width: passwordField.activeFocus ? 2 : 1; color: passwordField.activeFocus ? theme.borderFocused : theme.borderDefault }

            TextField {
                id: passwordField
                anchors { fill: parent; margins: 10 }
                placeholderText: "Contraseña"
                placeholderTextColor: theme.textPlaceholder
                color: theme.textPrimary
                font { family: theme.fontFamily; pixelSize: theme.fontSizeMedium }
                background: null
                maximumLength: 30
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: errorMessage !== ""
            text: errorMessage
            font { family: theme.fontFamily; pixelSize: theme.fontSizeSmall }
            color: theme.tableOccupied
        }

        Rectangle {
            Layout.fillWidth: true
            height: 50
            radius: theme.borderRadiusSmall
            color: mouseAreaLogin.containsPress ? theme.buttonPrimaryHover : theme.buttonPrimary

            Text {
                anchors.centerIn: parent
                text: isLoading ? "Cargando..." : "Ingresar"
                font { family: theme.fontFamily; pixelSize: theme.fontSizeMedium; bold: true }
                color: theme.textPrimary
            }

            MouseArea {
                id: mouseAreaLogin
                anchors.fill: parent
                enabled: !isLoading && idField.text !== "" && passwordField.text !== ""
                onClicked: {
                    loginScreen.isLoading = true
                    Login.loginAttempt(idField.text, passwordField.text)
                }
            }
        }
    }

    PopupComponent {
        id: errorPopup
        anchors.fill: parent
        theme: loginScreen.theme
        title: "Error al iniciar sesión"
        message: "Verifique Contraseña o Usuario"
        showCancelButton: false
    }
}
