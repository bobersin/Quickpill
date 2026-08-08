import QtQuick
import QtQuick.Controls
import QtMultimedia

ApplicationWindow {
    visible: true
    width: 400
    height: 250

    AudioOutput {
        id: audioOutput
        volume: 1.0
    }

    MediaPlayer {
        id: player
        source: "sfx/ping.mp3"
        audioOutput: audioOutput
    }

    Button {
        anchors.centerIn: parent
        text: "🔊 Play Ping"

        onClicked: {
            player.stop()
            player.play()
        }
    }
}