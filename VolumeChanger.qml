import QtQuick
import "components"

Item {
    id: root
    anchors.bottom: background.bottom
    anchors.left: background.left
    anchors.right: background.right
    enabled: false
    opacity: enabled ? 1 : 0
    property int radius: background.root.radius

    function start() {
        root.enabled = true
    }

    function exit() {
        root.enabled = false
    }
    IconButton {

    }
    Rectangle {
        id: expandedBackground
        width: background.width - 50
        anchors.horizontalCenter: root.horizontalCenter
        height: 30
        bottomLeftRadius: root.radius
        bottomRightRadius: root.radius
        color: curColor.background

        
    }
}