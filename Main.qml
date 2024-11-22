// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
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

        // Efeito de vidro aplicado a toda a imagem de fundo
        ShaderEffectSource {
            id: blurSource
            sourceItem: backgroundImage
            width: parent.width
            height: parent.height
            smooth: true
            hideSource: true
        }

        GaussianBlur {
            id: glassBlur
            width: parent.width
            height: parent.height
            source: blurSource
            radius: 20 // Ajuste o raio para controlar a intensidade do desfoque
            samples: 30
            anchors.fill: parent
            opacity: 0.6 // Leve transparência para o efeito de vidro
        }

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            color: "#000000"
            opacity: 0.2
            z: 1
        }

        LoginForm {
            id: form
            width: parent.width / 4
            height: parent.height / 2
            anchors.centerIn: parent
            z: 2
        }

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: config.background || config.Background
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
            visible: false // A imagem é usada apenas como fonte para o ShaderEffect
        }
    }
}
