//Clock.qml
//Add secs, fade in
//Add date, fade in
import QtQuick
import Quickshell

Text {
    id: textElement

    property bool hovered: parent.hoverOveride ? false : hoverHandler.hovered

    opacity: enabled ? 1 : 0
    anchors.horizontalCenter: parent.horizontalCenter
    y: hovered ? parent.maxHeight / 4 - tallText.height / 2 : (parent.minHeight - shortText.height) / 2
    color: Themes.current.colors.accent
    font.pixelSize: hovered ? 70 : 25
    text: Qt.formatDateTime(clock.date, "hh:mm A")

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    TextMetrics {
        id: shortText

        font.pixelSize: 25
        text: "12:59 AM"
    }

    TextMetrics {
        id: tallText

        font.pixelSize: 70
        text: "12:59 AM"
    }

    Behavior on font.pixelSize {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutCirc
        }

    }

    Behavior on y {
        SpringAnimation {
            spring: 3
            damping: 0.15
        }

    }

}
