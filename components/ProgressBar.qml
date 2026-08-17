import QtQuick
Item {
    id: root

    property real progress: 50
    property real length: 100
    property bool followMouseProgress: false

    width: 100
    height: 4

    signal released(point mouse, real startPos, real endPos)
    signal pressed(point mouse, real startPos, real endPos)

    Rectangle {
        id: backgroundBar
        anchors.fill: parent
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
                root.pressed(
                    Qt.point(selectionArea.mouseX, selectionArea.mouseY),
                    selectionArea.startPos,
                    selectionArea.endPos
                )
            }
            onReleased: {
                followMouse.running = false;
                progress = ((Math.min(Math.max(selectionArea.startPos, selectionArea.mouseX), selectionArea.endPos) - selectionArea.startPos) / (selectionArea.endPos - selectionArea.startPos)) * length
                root.released(
                    Qt.point(selectionArea.mouseX, selectionArea.mouseY),
                    selectionArea.startPos,
                    selectionArea.endPos
                )
            }

            FrameAnimation {
                id: followMouse

                onTriggered: {
                    handle.x = (Math.min(Math.max(selectionArea.startPos, selectionArea.mouseX), selectionArea.endPos)) - handle.width;
                    if (followMouseProgress)
                        progress = ((Math.min(Math.max(selectionArea.startPos, selectionArea.mouseX), selectionArea.endPos) - selectionArea.startPos) / (selectionArea.endPos - selectionArea.startPos)) * length
                }
            }

            FrameAnimation {
                id: followProgress

                running: true
                onTriggered: {
                    handle.x = ((progress / length) * root.width) - 8
                }
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