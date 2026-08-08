//Themes.qml
import QtQuick
import Quickshell.Io
pragma Singleton

QtObject {
    property var current: data.themes[data.current]
    property FileView jsonFile

    jsonFile: FileView {
        path: Qt.resolvedUrl("./themes.json")
        blockLoading: true
    }

    readonly property var data: JSON.parse(jsonFile.text())
}
