//shell.qml
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "components"

PanelWindow {
    id: root

    property var curColor: Themes.current.colors
    property int barSize: 12
    property int radius: 15
    focusable: true
    //WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    color: "transparent"
    mask: Region {item: backgroundInteraction}
    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    OpacityMask {
        anchors.fill: parent
        source: Rectangle {
            width: root.width
            height: root.height
            color: curColor.background
        }

        maskSource: Item {
            width: root.width
            height: root.height

            Rectangle {
                x: barSize
                y: barSize
                width: root.width - 2 * barSize
                height: root.height - 2 * barSize
                radius: root.radius
                color: "black"
            }
        }

        invert: true
    }

    Rectangle {
        id: background

        property var focusGrab: HyprlandFocusGrab {
            windows: [ root ]
        }

        property var root: root
        property int maxHeight: 450
        property int minHeight: 60
        property int maxWidth: 450
        property int minWidth: 150
        property bool moduleLocker: false
        property int lockedWidth: -1
        property int lockedHeight: -1
        property int leftExpansion: 0
        property int rightExpansion: 0
        property int topExpansion: 0

        color: curColor.background
        x: (root.width - width)/2
        height: lockedHeight != -1 ? lockedHeight : hoverHandler.hovered ? maxHeight : minHeight
        width: lockedWidth != -1 ? lockedWidth : hoverHandler.hovered ? maxWidth - root.radius * 2 : minWidth - root.radius * 2
        bottomLeftRadius: root.radius
        bottomRightRadius: root.radius
        Clock {
            id: clock
            z: 1
        }
        
        Loader {
            anchors.fill: parent
            id: musicPlayerLoader
            active: false
            source: "MusicPlayer.qml"
            z: 1
            Connections {
                target: musicPlayerLoader.item

                function onExited() {
                    musicPlayerLoader.active = false
                }
            }
        }
        Loader {
            id: appLauncherLoader
            anchors.fill: background
            active: false
            source: "AppLauncher.qml"
            z: 1
            Connections {
                target: appLauncherLoader.item

                function onExited() {
                    appLauncherLoader.active = false
                }
            }
        }
        MusicIndicator {
            id: musicIndicator
        }

        NotificationManager {
            id: notificationManager
        }

        VolumeChanger {
            id: volumeChanger
        }



        CornerConnector {
            radius: root.radius
            y: barSize
            x: background.width
            color: curColor.background
        }

        CornerConnector {
            radius: root.radius
            y: barSize
            x: - root.radius
            rotation: 90
            color: curColor.background
        }

        Behavior on height {
            NumberAnimation {
                id: heightChangeAnimation
                duration: 250
                easing.type: Easing.InOutCirc
                onRunningChanged: {
                    if (!running && hoverHandler.hovered && !background.moduleLocker) {
                        musicPlayerLoader.active = true
                        volumeChanger.start()
                    } else if (running && !hoverHandler.hovered) {
                        if (musicPlayerLoader.item)
                            musicPlayerLoader.item.exit()
                        volumeChanger.exit()
                    }
                }
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutCirc
            }

        }

    }

    Item {
        anchors.top: background.top
        id: backgroundInteraction
        x: background.x
        y: background.y
        width: background.width + background.leftExpansion + background.rightExpansion
        height: background.height + background.topExpansion
        HoverHandler {
            id: hoverHandler
        }
    }
    NotificationServer {
        onNotification: function(notification) {
            notificationManager.start(notification)
        }
    }

    IpcHandler {
        target: "background"

        function appLauncher(): void {
            appLauncherLoader.active = true
            if (musicPlayerLoader.item)
                musicPlayerLoader.item.exit()
            console.log("app launcher opened")
        }
    }
}