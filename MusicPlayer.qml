//MusicPlayer.qml
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import "components"

Item {
    id: root

    property var fadeInAnimation: fadeInAnimation
    property var fadeOutAnimation: fadeOutAnimation
    property int playerNum: 0
    property bool backgroundHovered: parent.hoverOveride ? false : hoverHandler.hovered

    signal exited

    Component.onCompleted: {
        fadeInAnimation.restart();
        for (let i = 0; i < Mpris.players.values.length; i++) {
            if (Mpris.players.values[i].isPlaying) {
                playerNum = i
                break
            }
        }
        vinylImage.source = Mpris.players.values[playerNum]?.trackArtUrl ?? "icons/black.png"
        vinylImage.rotationSpeed = Mpris.players.values[playerNum]?.isPlaying ? 0.5 : 0
        //enabled = true
        if (Mpris.players.values[playerNum])
            vinylImage.source = Mpris.players.values[playerNum]?.trackArtUrl;
    }

    function exit() {fadeOutAnimation.restart()}

    anchors.fill: parent

    WrapperItem {
        id: artCover

        property int minSize: 0
        property int size: 170
        property int maxSize: 170

        opacity: 0
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 75
        width: 170
        height: 170
        z: size > maxSize + 1 ? 1 : 0

        ClippingRectangle {
            id: vinyl

            anchors.centerIn: parent
            radius: width / 2
            rotation: 0

            Binding {
                target: vinyl
                property: "width"
                value: artCover.size
            }

            Binding {
                target: vinyl
                property: "height"
                value: artCover.size
            }

            Image {
                id: vinylImage
                property real angle: 0
                property real rotationSpeed: Mpris.players.values[playerNum]?.isPlaying ? 0.5 : 0
                source: Mpris.players.values[playerNum]?.trackArtUrl ?? "icons/black.png"
                anchors.fill: parent
                anchors.margins: -1
                transformOrigin: Item.Center
                rotation: vinylImage.angle
                Behavior on rotationSpeed {
                    NumberAnimation {
                        duration: 350
                    }
                }
            }
            
            MouseArea {
                id: vinylMouse
                anchors.fill: parent
                property var prevMouse: ({ x: -1, y: -1 })
                property var center: ({ x: vinyl.width / 2, y: vinyl.height / 2 })
                property real distance: 0
                property real tmpDistance: 0
                Timer {
                    id: trackMouse
                    interval: 25
                    triggeredOnStart: true
                    running: false
                    repeat: true
                    onTriggered: {
                        if (Mpris.players.values[playerNum])
                            Mpris.players.values[playerNum].seek(vinylMouse.distance)
                        vinylMouse.distance = 0
                    }
                }
                onPositionChanged: function(mouse) {
                    if (vinylMouse.prevMouse.x === -1 || vinylMouse.prevMouse.y == -1) {
                        vinylMouse.prevMouse.x = mouse.x
                        vinylMouse.prevMouse.y = mouse.y
                        return
                    }

                    tmpDistance = Math.atan2(mouse.y - center.y, mouse.x - center.x) - Math.atan2(prevMouse.y - center.y, prevMouse.x - center.x)

                    if (tmpDistance > Math.PI) {
                        tmpDistance -= 2 * Math.PI;
                    } else if (tmpDistance < -Math.PI) {
                        tmpDistance += 2 * Math.PI;
                    }

                    distance = distance + tmpDistance
                    vinylImage.angle = vinylImage.angle + tmpDistance * 75;
                    vinylMouse.prevMouse.x = mouse.x
                    vinylMouse.prevMouse.y = mouse.y
                }
                onPressed: {
                    trackMouse.start()
                    vinylImage.rotationSpeed = 0
                }
                onReleased: {
                    trackMouse.stop()
                    vinylImage.rotationSpeed = 0.5
                    vinylMouse.prevMouse.x = -1
                    vinylMouse.prevMouse.y = -1
                }
            }

            Rectangle {
                width: parent.width / 7
                height: parent.height / 7
                color: curColor.background
                radius: width / 2
                anchors.centerIn: parent
            }

            FrameAnimation {
                id: vinylRotationAnimation
                running: true
                onTriggered: {
                    vinylImage.angle = vinylImage.angle + vinylImage.rotationSpeed;
                }
            }

            Repeater {
                id: textureMaker

                model: 7

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width / textureMaker.model * index
                    height: parent.height / textureMaker.model * index
                    radius: width / 2
                    color: "transparent"
                    border.color: "black"
                }

            }

        }
    }

    ParallelAnimation {
        id: fadeOutVinyl

        NumberAnimation {
            target: vinyl
            property: "opacity"
            to: 0
            duration: 250
        }
        NumberAnimation {
            target: artCover
            property: "size"
            duration: 250
            to: artCover.minSize
            from: artCover.maxSize
            easing.type: Easing.OutQuart
        }
        onFinished: {
            fadeInVinyl.restart();
            vinylImage.source = Mpris.players.values[playerNum]?.trackArtUrl ?? "icons/black.png"
        }
    }

    ParallelAnimation {
        id: fadeInVinyl

        NumberAnimation {
            target: vinyl
            property: "opacity"
            to: 1
            duration: 250
        }

        SpringAnimation {
            target: artCover
            property: "size"
            to: artCover.maxSize
            from: artCover.minSize
            spring: 3.5
            damping: 0.25
        }
    }

    Connections {
        ignoreUnknownSignals: true
        function onTrackChanged() {
            fadeOutVinyl.restart();
            fadeInVinyl.stop();
            setFollowProgress.stop();
            followProgress.running = true;
        }

        target: Mpris.players.values[playerNum] ?? null
    }

    Item {
        id: controlButtons

        property int offset: 5
        property int size: 35
        property var list: [switchPlayer, shuffleButton, previousButton, playButton, skipButton, loopButton]

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 75
        anchors.rightMargin: 30
        height: 50
        width: artCover.width

        IconButton {
            id: shuffleButton
            opacity: 0
            width: parent.size - 8
            height: parent.size - 8
            icon.source: "icons/shuffle.svg"
            icon.color: Mpris.players.values[root.playerNum]?.shuffle ? curColor.border : curColor.accent
            anchors.verticalCenter: parent.verticalCenter
            x: (parent.width / 2 - parent.size / 2) - (parent.size + parent.offset * 2 + parent.size) + 8
            onClicked: {
                if (Mpris.players.values[root.playerNum]?.shuffleSupported)
                    Mpris.players.values[root.playerNum].shuffle = !Mpris.players.values[root.playerNum].shuffle
            }
        }

        IconButton {
            id: previousButton

            opacity: 0
            width: parent.size
            height: parent.size
            x: (parent.width / 2 - parent.size / 2) - (parent.size + parent.offset)
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "icons/previous.svg"
            icon.color: curColor.accent
            onClicked: {
                if (Mpris.players.values[root.playerNum]?.canGoPrevious) {
                    Mpris.players.values[root.playerNum]?.previous()
                    if (Mpris.players.values[playerNum])
                        Mpris.players.values[playerNum].position = 0
                }
            }
        }

        IconButton {
            id: playButton

            opacity: 0
            width: parent.size
            height: parent.size
            x: (parent.width / 2 - parent.size / 2)
            anchors.verticalCenter: parent.verticalCenter
            icon.source: Mpris.players.values[root.playerNum]?.isPlaying ? "icons/playing.svg" : "icons/paused.svg"
            icon.color: Mpris.players.values[root.playerNum]?.isPlaying ? curColor.border : curColor.accent
            onClicked: {
                if (Mpris.players.values[root.playerNum]?.canTogglePlaying) {
                    Mpris.players.values[root.playerNum]?.togglePlaying()
                    vinylImage.rotationSpeed = vinylImage.rotationSpeed > 0.01 ? 0 : 0.5
                }
            }
        }

        IconButton {
            id: skipButton

            opacity: 0
            width: parent.size
            height: parent.size
            x: (parent.width / 2 - parent.size / 2) + (parent.size + parent.offset)
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "icons/skip.svg"
            icon.color: curColor.accent
            onClicked: {
                if (Mpris.players.values[root.playerNum]?.canGoNext)
                    Mpris.players.values[root.playerNum]?.next()
            }
        }

        IconButton {
            id: loopButton

            opacity: 0
            width: parent.size - 8
            height: parent.size - 8
            x: (parent.width / 2 - parent.size / 2) + (parent.size + parent.offset * 2 + parent.size) 
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "icons/loop.svg"
            icon.color: curColor.accent
        }

    }

    IconButton {
        id: switchPlayer

        opacity: 0
        x: artCover.x
        y: artCover.y
        height: 25
        width: 25
        icon.source: "icons/switchPlayer.svg"
        icon.color: curColor.accent
        onClicked: {
            root.playerNum = root.playerNum + 1 < Mpris.players.values.length ? root.playerNum + 1 : 0;
            progressBar.length = Mpris.players.values[playerNum]?.length ?? 0
            fadeOutVinyl.restart();
            fadeInVinyl.stop();
            vinylImage.rotationSpeed = Mpris.players.values[playerNum].isPlaying ? 0.5 : 0
        }
        fadeInDuration: 250
    }

    ProgressBar {
        id: progressBar
        opacity: 0
        progress: Mpris.players.values[playerNum]?.position ?? 0
        length: Mpris.players.values[playerNum]?.length ?? 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (parent.height - (artCover.y + artCover.height)) / 2
        width: background.width - 100
        FrameAnimation {
            running: true
            onTriggered: progressBar.progress = Mpris.players.values[playerNum]?.position ?? 0
        }
        onReleased: function(mouse, startPos, endPos) {
            if (Mpris.players.values[playerNum])
                Mpris.players.values[playerNum].position = (Math.min(Math.max(startPos, mouse.x), endPos) - 8) / 312 * length
        }
    }

    Item {
        id: discription

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 75
        anchors.rightMargin: 30
        width: artCover.width
        height: artCover.height

        Text {
            id: title

            opacity: 0
            text: Mpris.players.values[playerNum]?.trackTitle ?? "No Track Found"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: artCover.y
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
        }

    }

    SequentialAnimation {
        id: fadeInAnimation

        onStarted: {
            buttonFadeInAnimation.restart()
        }

        NumberAnimation {
            from: 0
            to: 1
            target: artCover
            property: "opacity"
            duration: 250
        }

        NumberAnimation {
            from: 0
            to: 1
            target: title
            property: "opacity"
            duration: 250
        }

        NumberAnimation {
            target: progressBar
            property: "opacity"
            from: 0
            to: 1
            duration: 250
        }
        onStopped: {
            buttonFadeInAnimation.stop()
            buttonFadeInAnimation.index = 0
        }
    }

    Timer {
        id: buttonFadeInAnimation
        property int index: 0
        interval: controlButtons.list[index].fadeInDuration
        triggeredOnStart: true
        repeat: true
        running: false
        onTriggered: {
            controlButtons.list[index].fadeIn.start()
            if (index >= controlButtons.list.length - 1) {
                index = 0
                stop()
                return
            }
            index = index + 1
        }
    }

    ParallelAnimation {
        id: fadeOutAnimation

        onStarted: {
            fadeInAnimation.stop();
            controlButtons.list.forEach(button => button.fadeOut.restart())
        }

        NumberAnimation {
            to: 0
            target: artCover
            property: "opacity"
            duration: 135
        }

        NumberAnimation {
            to: 0
            target: title
            property: "opacity"
            duration: 135
        }

        NumberAnimation {
            target: progressBar
            property: "opacity"
            to: 0
            duration: 135
        }
        onStopped: controlButtons.list.forEach(button => button.fadeOut.stop())
        onFinished: exited()
    }
    
}