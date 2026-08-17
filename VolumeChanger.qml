import QtQuick
import "components"
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Item {
    id: root
    anchors.left: background.left
    anchors.bottom: background.bottom
    width: background.width
    height: 50
    //enabled: false
    //opacity: enabled ? 1 : 0
    opacity: 1
    readonly property real volume: Pipewire.defaultAudioSink.audio.volume
    property int radius: background.root.radius
    property var topExpansion: background.topExpansion

    Binding {
        target: background
        property: "topExpansion"
        value: root.topExpansion
    }

    function start() {
        root.enabled = true
    }

    function exit() {
        root.enabled = false
        background.topExpansion = 0
    }
    PwObjectTracker {objects: [Pipewire.defaultAudioSink]}

    IconButton {
        anchors.bottom: parent.bottom
        //anchors.left: parent.left
        icon.source: volume === 0 ? "icons/volumeMuted.svg" :
                    volume <= 1/3 ? "icons/volume1.svg" :
                    volume <= 2/3 ? "icons/volume2.svg" : "icons/volume3.svg"
        
        onPressed: {
            expandedBackground.enabled = !expandedBackground.enabled
            root.topExpansion = expandedBackground.enabled ? expandedBackground.targetHeight : 0
            console.log(expandedBackground.enabled ? expandedBackground.targetHeight : 0)
        }
        width: 35
        height: 35
        
        //y: -(height + 5)
        z: 1
    }

    ClippingRectangle {
        id: expandedBackground
        property int targetHeight: 40
        y: root.height
        enabled: false && root.enabled
        width: background.width - 50
        anchors.horizontalCenter: root.horizontalCenter
        height: enabled ? targetHeight : 0
        bottomLeftRadius: root.radius
        bottomRightRadius: root.radius
        color: curColor.background
        ProgressBar {
            y: (expandedBackground.targetHeight - height)/2
            x: (expandedBackground.width - width)/2
            width: parent.width - 100
            length: 1
            progress: volume
            followMouseProgress: true
            onProgressChanged: {
                Pipewire.defaultAudioSink.audio.volume = progress
            }
        }

        Behavior on height {   
            NumberAnimation {
                duration: 250
                easing.overshoot: 10
                easing.type: Easing.OutCubic
            }
        }
    }
}