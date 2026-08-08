//CornerConnector.qml
import QtQuick
import QtQuick.Shapes

Shape {
    property int radius: 50
    property color color: "white"

    transformOrigin: Item.Center
    width: radius
    height: radius

    ShapePath {
        fillColor: color
        strokeColor: color
        startX: 0
        startY: 0

        PathLine {
            x: 0
            y: radius
        }

        PathArc {
            radiusX: radius
            radiusY: radius
            x: radius
            y: 0
        }

    }

}
