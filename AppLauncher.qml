import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "fuse.min.js" as FuseScript

ClippingRectangle {
    id: root

    property int selectionIndex: 0
    property int maxItems: 10
    property int listOffset: 75
    property int windowHeight: listOffset + list.height + (list.spacing * Math.min(list.height, 1))
    property var fuse: new Fuse(DesktopEntries.applications.values, {
        "keys": ["name", "genericName", "keywords"]
    })
    property var sortedList: fuse.search(userInput.text)
    property int curMaxItems: Math.min(maxItems, sortedList.length)

    Component.onCompleted: {
        background.moduleLocker = true;
        background.lockedWidth = 400;
        background.lockedHeight = windowHeight;
        background.focusGrab.active = true;
        userInput.forceActiveFocus();
        clock.enabled = false;
    }

    Component.onDestruction: {
        background.moduleLocker = false;
        background.lockedWidth = -1;
        background.lockedHeight = -1;
        background.focusGrab.active = false;
        clock.enabled = true;
    }

    signal exited

    color: "transparent"
    anchors.fill: appLauncherLoader
    onWindowHeightChanged: {
        if (enabled)
            background.lockedHeight = windowHeight;
    }
    onSelectionIndexChanged: {
        selectionIndex = selectionIndex < 0 ? selectionIndex = curMaxItems - 1 : selectionIndex < curMaxItems ? selectionIndex : 0;
    }

    Region {
        id: restrictedRegion

        item: background
    }

    TextField {
        id: userInput

        opacity: 1
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        anchors.top: parent.top
        height: 45
        anchors.topMargin: 15
        leftPadding: height / 2
        color: "white"
        placeholderText: "Search . . ."
        placeholderTextColor: curColor.highlightDark
        Keys.onEscapePressed: root.exited()
        Keys.onDownPressed: selectionIndex++
        Keys.onTabPressed: selectionIndex++
        Keys.onBacktabPressed: selectionIndex--
        Keys.onUpPressed: selectionIndex--
        onAccepted: {
            sortedList[selectionIndex].item.execute();
            root.exited();
        }

        background: Rectangle {
            color: "transparent"
            anchors.fill: parent
            border.color: curColor.accent
            radius: height / 2
        }

    }

    Column {
        id: list

        spacing: 15
        anchors.horizontalCenter: parent.horizontalCenter
        y: listOffset

        Repeater {
            model: sortedList.length <= maxItems ? sortedList.length : maxItems

            Rectangle {
                property QtObject curItem: sortedList[index].item

                visible: enabled
                anchors.horizontalCenter: parent.horizontalCenter
                width: 300
                height: 40
                radius: height / 2
                color: index === selectionIndex ? curColor.highlightLight : curColor.highlightDark

                Text {
                    color: "white"
                    text: curItem.name
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                Image {
                    source: "image://icon/" + curItem.icon
                    x: radius
                    height: parent.height - 4
                    y: 2
                    width: height
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        curItem.execute();
                        root.exited();
                    }
                    onPositionChanged: {
                        selectionIndex = index;
                    }
                }

            }

        }

    }

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }

    }

}
