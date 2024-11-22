import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: clock
    spacing: 0
    width: parent.width / 3

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Rajdhani"
        font.pointSize: root.font.pointSize * 3
        color: "#e8615a"
        text: config.HeaderText
    }

    Label {
        id: timeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Rajdhani"
        font.pointSize: root.font.pointSize * 4
        color: "#fada16"
        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(config.Locale), config.HourFormat == "long" ? Locale.LongFormat : Locale.ShortFormat)
        }
    }

    Label {
        id: dateLabel
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#e8615a"
        font.family: "Rajdhani"
        font.pointSize: root.font.pointSize * 1.25
        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(config.Locale), config.DateFormat == "short" ? Locale.ShortFormat : Locale.LongFormat)
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
