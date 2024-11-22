// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: sessionButton
    height: root.font.pointSize
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter
    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property Control exposeSession: selectSession

    ComboBox {
        id: selectSession
        width: sessionButton.width * 0.9
        height: root.font.pointSize * 2
        hoverEnabled: true
        anchors.left: parent.left

        Keys.onPressed: {
            if (event.key == Qt.Key_Up && loginButton && !popup.opened) {
                loginButton.forceActiveFocus();
            } else if (event.key == Qt.Key_Down && systemButtons && !popup.opened) {
                systemButtons.children[0].forceActiveFocus();
            } else if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
                popup.open();
            }
        }

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        delegate: ItemDelegate {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                font.family: root.font.family
                color: selectSession.highlightedIndex === index ? root.palette.highlight : root.palette.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? root.palette.highlight : "transparent"
            }
        }

        contentItem: Text {
            id: displayedItem
            text: selectSession.currentText
            color: root.palette.text
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 3
            font.pointSize: root.font.pointSize * 0.8
            font.family: root.font.family
        }

        background: Rectangle {
            color: "transparent"
            border.width: parent.visualFocus ? 1 : 0
            border.color: root.palette.highlight
        }

        popup: Popup {
            id: popupHandler
            y: parent.height - 1
            x: config.ForceRightToLeft == "true" ? -loginButtonWidth + displayedItem.width : 0
            width: sessionButton.width
            implicitHeight: contentItem.implicitHeight
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
            onOpened: opacity = 1
            onClosed: opacity = 0

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight + 20
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: config.RoundCorners / 2
                color: config.BackgroundColor
                border.color: root.palette.highlight
                border.width: 1
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 10
                    radius: 15
                    samples: 25
                    cached: true
                    color: Qt.rgba(0, 0, 0, 0.5)
                }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectSession.down
                PropertyChanges {
                    target: displayedItem
                    color: Qt.darker(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.darker(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    color: Qt.lighter(root.palette.highlight, 1.1)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.lighter(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    color: root.palette.highlight
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: root.palette.highlight
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]
    }
}
