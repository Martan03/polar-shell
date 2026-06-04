import QtQuick
import "../Services"

Rectangle {
    id: root

    property string icon: ""
    property int iconSize: 18
    property color iconColor: Theme.primary
    property int size: 25

    property int iconOffsetX: 0
    property int iconOffsetY: 0

    property color bg: Qt.rgba(Theme.border.r, Theme.border.g, Theme.border.b, 0)
    property color hoverBg: Theme.border

    signal clicked

    implicitWidth: size
    implicitHeight: size
    radius: size / 2

    color: hover.hovered ? hoverBg : bg
    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    NerdIcon {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.iconOffsetX
        anchors.verticalCenterOffset: root.iconOffsetY
        icon: root.icon
        color: root.iconColor
        size: root.iconSize
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: root.clicked()
    }
}
