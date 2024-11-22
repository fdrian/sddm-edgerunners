// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0 as SDDM

Item {
    id: formContainer
    anchors.centerIn: parent

    SDDM.TextConstants { id: textConstants }

    property int p: config.ScreenPadding
    property string a: config.FormPosition
    property alias systemButtonVisibility: systemButtons.visible
    property alias clockVisibility: clock.visible
    property bool virtualKeyboardActive

    // Efeito de vidro: desfoque com opacidade apenas no fundo do LoginForm
    ShaderEffectSource {
        id: blurSource
        sourceItem: backgroundImage // Defina o item de fundo da interface como fonte
        width: formContainer.width
        height: formContainer.height
        smooth: true
        hideSource: true
        sourceRect: Qt.rect(formContainer.x, formContainer.y, formContainer.width, formContainer.height) // Captura apenas a área do formulário
    }

    GaussianBlur {
        id: glassBlur
        width: formContainer.width
        height: formContainer.height
        source: blurSource
        radius: 40
        samples: 30
        anchors.fill: parent
        opacity: 0.9
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.8
        radius: 0
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 20 // Margem para separar o conteúdo do fundo desfocado

        Clock {
            id: clock
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.preferredHeight: formContainer.height / 3
            Layout.leftMargin: p != "0" ? (a == "left" ? -p : (a == "right" ? p : 0)) : 0
        }

        Input {
            id: input
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: formContainer.height / 10
            Layout.leftMargin: p != "0" ? (a == "left" ? -p : (a == "right" ? p : 0)) : 0
            Layout.topMargin: virtualKeyboardActive ? -height * 1.5 : 0
        }

        SystemButtons {
            id: systemButtons
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.preferredHeight: formContainer.height / 4
            Layout.maximumHeight: formContainer.height / 4
            Layout.leftMargin: p != "0" ? (a == "left" ? -p : (a == "right" ? p : 0)) : 0
            exposedSession: input.exposeSession
        }
    }
}
