import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

Rectangle {
    id: root

    property bool active: false
    required property string icon
    required property string label

    property real iconSize: 20
    property string sublabel: ""

    signal clicked

    implicitHeight: 60
    implicitWidth: 135
    radius: 12

    color: active ? Theme.primary : Theme.border
    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        NerdIcon {
            icon: root.icon
            size: root.iconSize
            color: root.active ? Theme.surface : Theme.primary
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            StyledText {
                text: root.label
                font.bold: true
                color: root.active ? Theme.surface : Theme.primary
            }

            StyledText {
                text: root.sublabel
                font.pixelSize: 11
                color: root.active ? Theme.border : Theme.muted
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
