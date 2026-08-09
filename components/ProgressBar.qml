Item {
    id: root

    property real progress: 0
    property real length: 100

    Rectangle {
        id: backgroundBar
        width: 100
        height: 4
        radius: height / 2

        MouseArea {
            id: selectionArea

            property int startPos: parent.height * 2
            property int endPos: width - parent.height * 2

            height: parent.height * 5
            width: parent.width + parent.height * 2
            x: -parent.height * 2
            y: -parent.height * 2
            onPressed: {
                followProgress.running = false;
                followMouse.running = true;
            }
            onReleased: {
                setFollowProgress.start();
                followMouse.running = false;
                function
            }

            FrameAnimation {
                id: followMouse

                onTriggered: {
                    handle.x = Math.min(Math.max(selectionArea.startPos, selectionArea.mouseX), selectionArea.endPos) - handle.width;
                }
            }

            FrameAnimation {
                id: followProgress

                running: true
                onTriggered: {
                    handle.x = Math.min(Math.max(selectionArea.startPos, progressBar.progress / progressBar.length * selectionArea.width), selectionArea.endPos) - handle.width;
                }
            }

        }

        FrameAnimation {
            id: setFollowProgress

            running: true
            onTriggered: {
                if (Mpris.players.values[playerNum]?.position === (Math.min(Math.max(selectionArea.startPos, selectionArea.mouseX), selectionArea.endPos) - 8) / 312 * progressBar.length)
                    followProgress.running = true;

            }
        }

        Rectangle {
            id: handle

            width: parent.height * 3
            height: parent.height * 3
            x: -parent.height * 1
            y: -parent.height * 1
            z: 1
            radius: height / 2
            color: curColor.border
        }

        FrameAnimation {
            running: true
            onTriggered: progressBar.progress = Mpris.players.values[playerNum]?.position ?? 0
        }

    }

    Rectangle {
        id: filledBar

        x: backgroundBar.x - 1
        y: backgroundBar.y - 1
        height: backgroundBar.height + 2
        width: handle.x + 1
        radius: backgroundBar.radius
        color: curColor.border
        anchors.left: backgroundBar.left
    }

}