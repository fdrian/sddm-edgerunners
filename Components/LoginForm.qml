// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
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


    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.8
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 20

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
