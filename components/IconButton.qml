import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

AbstractButton {
    id: root
    property alias fadeIn: fadeIn
    property int fadeInDuration: 100
    property alias fadeOut: fadeOut
    property int fadeOutDuration: 135
    icon.width: width
    icon.height: height
    contentItem: Item {
        Image {
            id: iconImage

            source: "../" + icon.source
            anchors.centerIn: parent
            width: icon.width
            height: icon.height
            visible: true
        }

        ColorOverlay {
            source: iconImage
            color: icon.color
            anchors.fill: iconImage
        }

    }

    NumberAnimation {
        id: fadeIn
        from: 0
        to: 1
        target: root
        property: "opacity"
        duration: fadeInDuration
    }
    
    NumberAnimation {
        id: fadeOut
        to: 0
        target: root
        property: "opacity"
        duration: fadeOutDuration
    }

}