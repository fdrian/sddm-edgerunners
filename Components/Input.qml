import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Column {
    id: inputContainer
    Layout.fillWidth: true

    property Control exposeSession: sessionSelect.exposeSession
    property bool failed

    Item {
        height: root.font.pointSize * 2
        width: 300
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            id: errorMessage
            width: parent.width
            text: failed ? config.TranslateLoginFailedWarning || "Login failed!" : keyboard.capsLock ? "Caps Lock is ON" : null
            horizontalAlignment: Text.AlignHCenter
            font.family: "Rajdhani"
            font.pointSize: root.font.pointSize * 0.8
            font.italic: true
            color: "#e8615a"
            opacity: 0
            states: [
                State {
                    name: "fail"
                    when: failed
                    PropertyChanges { target: errorMessage; opacity: 0.8 }
                },
                State {
                    name: "capslock"
                    when: keyboard.capsLock
                    PropertyChanges { target: errorMessage; opacity: 0.8 }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation { properties: "opacity"; duration: 200 }
                }
            ]
        }
    }

    Item {
        id: usernameField
        height: root.font.pointSize * 4.5
        width: 400
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: username
            font.family: "Rajdhani"
            font.bold: true
            color: "#e8615a"
            placeholderText: config.TranslatePlaceholderUsername || "Username"
            placeholderTextColor: "#9c3230"
            width: parent.width
            height: 46

            background: Rectangle {
                width: parent.width
                height: parent.height
                color: "black"
                border.color: "transparent"

                Rectangle {
                    id: bottomBorder
                    width: parent.width
                    height: 2
                    color: username.activeFocus ? "#FADA16" : "#101010"
                    anchors.bottom: parent.bottom
                }
            }

            onAccepted: config.AllowBadUsernames == "false" 
                ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) 
                : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: password
        }
    }

    Item {
        id: passwordField
        height: root.font.pointSize * 4.5
        width: 400
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: password
            font.family: "Rajdhani"
            font.bold: true
            echoMode: TextInput.Password
            color: "#e8615a"
            placeholderText: config.TranslatePlaceholderPassword || "Password"
            placeholderTextColor: "#9c3230"            
            width: parent.width
            height: 46

            background: Rectangle {
                width: parent.width
                height: parent.height
                color: "black"
                border.color: "transparent"

                Rectangle {
                    id: bottomBorderPassword
                    width: parent.width
                    height: 2
                    color: password.activeFocus ? "#FADA16" : "#101010"
                    anchors.bottom: parent.bottom
                }
            }

            onAccepted: config.AllowBadUsernames == "false" 
                ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) 
                : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: loginButton
        }
    }

    Item {
        id: login
        height: root.font.pointSize * 9
        width: 400
        anchors.horizontalCenter: parent.horizontalCenter
        visible: config.HideLoginButton == "true" ? false : true

        Button {
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: config.TranslateLogin || "Login"
            height: root.font.pointSize * 3
            width: 400
            enabled: config.AllowEmptyPassword == "true" || (username.text !== "" && password.text !== "") ? true : false

            background: Rectangle {
                id: buttonBackground
                color: "#FADA16"
                radius: 5
            }

            states: [
                State {
                    name: "pressed"
                    when: loginButton.down
                    PropertyChanges { target: buttonBackground; color: Qt.darker("#FADA16", 1.1) }
                },
                State {
                    name: "hovered"
                    when: loginButton.hovered
                    PropertyChanges { target: buttonBackground; color: "cyan" }
                },
                State {
                    name: "focused"
                    when: loginButton.activeFocus
                    PropertyChanges { target: buttonBackground; color: Qt.lighter("#FADA16", 1.2) }
                },
                State {
                    name: "enabled"
                    when: loginButton.enabled
                    PropertyChanges { target: buttonBackground; color: "#FADA16" }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation { properties: "color"; duration: 300 }
                }
            ]
            onClicked: config.AllowBadUsernames == "false" 
                ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) 
                : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            Keys.onReturnPressed: clicked()
            Keys.onEnterPressed: clicked()
        }
    }

    SessionButton {
        id: sessionSelect
        loginButtonWidth: loginButton.width
    }

    Connections {
        target: sddm
        onLoginSucceeded: { failed = false }
        onLoginFailed: {
            failed = true
            resetError.running ? resetError.restart() : resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
}
