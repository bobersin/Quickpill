import QtMultimedia
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

ClippingRectangle {
/*         Row { //Left to right
        id: rowLayout

        spacing: 3
        anchors.fill: parent

        Repeater {
            model: numBands

            Rectangle {
                height: frequencies[index] * parent.height / 7
                color: curColor.border//curColor.accent
                anchors.bottom: parent.bottom
                width: rowLayout.width / numBands - rowLayout.spacing

                Behavior on height {
                    NumberAnimation {
                        duration: 75
                        easing.type: Easing.Linear
                    }
                }
            }
        }
    } */

    id: root

    property int numBands: 7
    property var frequencies: []

    //width: 45
    //height: 40
    //anchors.right: parent.right
    //anchors.rightMargin: rowLayout.spacing
    //anchors.verticalCenter: parent.verticalCenter
    anchors.fill: parent
    radius: 5
    color: "transparent"

    // Center to Outward
    Repeater {
        id: barMaker

        property int spacing: 3

        model: numBands

        Item {
            anchors.fill: parent

            Rectangle {
                height: frequencies[index] * parent.height / 7
                color: curColor.border
                anchors.bottom: parent.bottom
                width: parent.width / (numBands * 2 - 1) - barMaker.spacing
                x: (root.width - width) / 2 + (width + barMaker.spacing) * index

                Behavior on height {
                    NumberAnimation {
                        duration: 75
                        easing.type: Easing.Linear
                    }

                }

            }

            Rectangle {
                height: frequencies[index] * parent.height / 7
                color: curColor.border
                anchors.bottom: parent.bottom
                width: parent.width / (numBands * 2 - 1) - barMaker.spacing
                x: (root.width - width) / 2 - (width + barMaker.spacing) * index

                Behavior on height {
                    NumberAnimation {
                        duration: 75
                        easing.type: Easing.Linear
                    }

                }

            }

        }

    }

    Process {
        running: true
        command: ["node", Quickshell.shellDir + "/audioCapture.js", +numBands]

        stdout: SplitParser {
            onRead: function(line) {
                frequencies = JSON.parse(line);
            }
        }

    }

}
