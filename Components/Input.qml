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
            text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + "!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : null
            horizontalAlignment: Text.AlignHCenter
            font.family: "VT323"
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
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            placeholderTextColor: "#9c3230"
            width: parent.width
            height: 46

            background: Rectangle {
                width: parent.width
                height: parent.height
                color: "#101010"
                border.color: "#101010"
                border.width: 2
                radius: 0

                // Borda inferior destacada
                Rectangle {
                    id: bottomLoginBorder
                    width: parent.width
                    height: 2
                    color: username.activeFocus ? "#FADA16" : "transparent"
                    anchors.bottom: parent.bottom
                }
            }

            onAccepted: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: showPassword
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
            placeholderText: config.TranslatePlaceholderPassword || textConstants.password
            placeholderTextColor: "#9c3230"
            width: parent.width
            height: 46

            background: Rectangle {
                width: parent.width
                height: parent.height
                color: "#101010"
                border.color: "#101010"
                border.width: 2
                radius: 0

                // Borda inferior destacada
                Rectangle {
                    id: bottomPasswordBorder
                    width: parent.width
                    height: 2
                    color: password.activeFocus ? "#FADA16" : "transparent"
                    anchors.bottom: parent.bottom
                }
            }

            onAccepted: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: loginButton
        }
    }

    Item {
    id: login
    height: root.font.pointSize * 9
    width: 400 // Largura fixa do botão
    anchors.horizontalCenter: parent.horizontalCenter
    visible: config.HideLoginButton == "true" ? false : true

    Button {
        id: loginButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: config.TranslateLogin || textConstants.login
        height: root.font.pointSize * 3
        width: 400 
        enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
        hoverEnabled: true

        contentItem: Text {
            text: parent.text
            color: "black" 
            font.pointSize: root.font.pointSize
            font.family: root.font.family
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: 1
        }

        background: Rectangle {
            id: buttonBackground
            color: "#FADA16" // Amarelo de fundo padrão
            opacity: 1
            radius: 0 // Remove o arredondamento
        }

        states: [
            State {
                name: "pressed"
                when: loginButton.down
                PropertyChanges {
                    target: buttonBackground
                    color: Qt.darker("#FADA16", 1.1) // Escurece um pouco no clique
                    opacity: 1
                }
                PropertyChanges {
                    target: loginButton.contentItem
                }
            },
            State {
                name: "hovered"
                when: loginButton.hovered
                PropertyChanges {
                    target: buttonBackground
                    color: "cyan" // Cor ciano ao passar o mouse
                    opacity: 1
                }
                PropertyChanges {
                    target: loginButton.contentItem
                    opacity: 1
                }
            },
            State {
                name: "focused"
                when: loginButton.activeFocus
                PropertyChanges {
                    target: buttonBackground
                    color: Qt.lighter("#FADA16", 1.2) // Mantém o amarelo ao focar
                    opacity: 1
                }
                PropertyChanges {
                    target: loginButton.contentItem
                    opacity: 1
                }
            },
            State {
                name: "enabled"
                when: loginButton.enabled
                PropertyChanges {
                    target: buttonBackground
                    color: "#FADA16"
                    opacity: 1
                }
                PropertyChanges {
                    target: loginButton.contentItem
                    opacity: 1
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "opacity, color"
                    duration: 300
                }
            }
        ]
        onClicked: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
        Keys.onReturnPressed: clicked()
        Keys.onEnterPressed: clicked()
        KeyNavigation.down: sessionSelect.exposeSession
    }
}

    
    SessionButton {
        id: sessionSelect
        loginButtonWidth: loginButton.background.width
    }
    Connections {
        target: sddm
        onLoginSucceeded: {}
        onLoginFailed: {
            failed = true
            resetError.running ? resetError.stop() && resetError.start() : resetError.start()
        }
    }
        Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
    
}

