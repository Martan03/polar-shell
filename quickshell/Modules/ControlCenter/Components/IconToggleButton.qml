import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

Rectangle {
    id: root

    property bool active: false
    required property string icon
    property real iconSize: 20

    property real size: 60

    signal clicked

    implicitHeight: size
    implicitWidth: size
    radius: 12

    color: active ? Theme.primary : Theme.border
    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    NerdIcon {
        anchors.centerIn: parent
        icon: root.icon
        size: root.iconSize
        color: root.active ? Theme.surface : Theme.primary
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
