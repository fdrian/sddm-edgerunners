// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth
    padding: config.ScreenPadding
    palette.button: "transparent"
    palette.highlight: "#e8615a"
    palette.highlightedText: "#f4908b"
    palette.text: "#e8615a"
    palette.buttonText: "#000000"
    palette.window: "#191a1e"
    font.family: "Rajdhani"
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    Item {
        id: sizeHelper
        anchors.fill: parent

        // Fundo de fallback caso a imagem não carregue
        Rectangle {
            id: backgroundLayer
            anchors.fill: parent
            color: "#191a1e"
        }


        Image {
            id: backgroundImage
            anchors.fill: parent
            source: config.background || config.Background
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            mipmap: true
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            sourceItem: backgroundImage
            width: form.width
            height: parent.height
            anchors.centerIn: form
            sourceRect: Qt.rect(x,y,width,height)
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }
        
        // Camada de tonalidade para escurecer o fundo
        Rectangle {
            id: tintLayer
            anchors.fill: parent
            color: "#000000"
            opacity: 0.2
            z: 1
        }

        // Formulário de login
        LoginForm {
            id: form
            width: parent.width / 4
            height: parent.height / 2
            anchors.centerIn: parent
            z: 2
        }
    }
}
