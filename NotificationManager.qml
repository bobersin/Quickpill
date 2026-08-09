import QtQuick
import QtMultimedia
Item {
    id: root
    height: parent.height
    property var lastNotification: null
    function start(notification) {
        background.moduleLocker = true;
        background.lockedWidth = 400;
        background.lockedHeight = 100;
        clock.enabled = false;
        enabled = true;
        mainText.body = notification.body
        mainText.summary = notification.summary
        mainText.appName = notification.appName
        image.source = notification.image
        lastNotification = notification
        ping.stop()
        ping.play()
        expireTimer.restart()
    }

    function exit() {
        background.moduleLocker = false;
        background.lockedWidth = -1;
        background.lockedHeight = -1;
        clock.enabled = true;
        enabled = false;
        image.source = ""
        expireTimer.stop()
    }
    Item {
        id: mainText
        opacity: enabled ? 1 : 0
        property string body: ""
        property string summary: ""
        property string appName: ""
        property color color: curColor.accent
        anchors.left: parent.left
        anchors.leftMargin: 100
        Text {
            text: parent.appName
            font.pixelSize: 18
            font.family: "Sans"
            color: parent.color
            y: 2
            anchors.left: parent.left
            anchors.leftMargin: -15
        }
        Text {
            text: parent.summary
            font.pixelSize: 16
            color: parent.color
            y: 25
        }
        Text {
            text: parent.body
            font.pixelSize: 12
            color: parent.color
            y: 45
            maximumLineCount: 3
            width: 295
            elide: Text.ElideRight
            wrapMode: Text.Wrap
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
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