import QtQuick
import "../../../Services"

Item {
    id: root

    property real size: 6
    property real margin: 6

    implicitWidth: size + margin
    implicitHeight: parent.height
    visible: Capture.captureState !== Capture.stateIdle && Capture.captureState !== Capture.stateStopping

    Rectangle {
        anchors.centerIn: parent
        width: root.size
        height: root.size
        radius: root.size / 2

        color: Capture.captureState === Capture.stateStarting ? "#e67e22" : "#e74c3c"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Capture.toggle()
    }
}
