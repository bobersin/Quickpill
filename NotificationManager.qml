import QtQuick
import QtMultimedia
Item {
    id: root
    height: parent.height
    property var lastNotification: null
    function start(notification) {
        background.hoverOveride = true;
        background.lockedWidth = 400;
        background.lockedHeight = 100;
        clock.enabled = false;
        enabled = true;
        bodyText.text = notification.body
        image.source = notification.image
        lastNotification = notification
        ping.stop()
        ping.play()
        expireTimer.restart()
    }

    function exit() {
        background.hoverOveride = false;
        background.lockedWidth = -1;
        background.lockedHeight = -1;
        clock.enabled = true;
        enabled = false;
        bodyText.text = ""
        image.source = ""
        expireTimer.stop()
    }

    Text {
        id: bodyText
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.verticalCenter: parent.verticalCenter
        color: curColor.accent
    }
    Image {
        id: image
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        width: 80
        height: 80
    }

    MediaPlayer {
        id: ping
        source: "sfx/ping.mp3"
        audioOutput: AudioOutput {
            volume: 1.0
        }
    }

    Timer {
        id: expireTimer
        interval: 3000
        onTriggered: {
            lastNotification?.expire()
            exit()
        }
    }
}