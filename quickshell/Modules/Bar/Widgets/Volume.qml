import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../Services"
import "../../../Widgets"

Item {
    id: root

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    Process {
        id: pavuControlLauncher
        command: ["pavucontrol"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            pavuControlLauncher.running = true;
        }
    }

    RowLayout {
        id: contentRow
        spacing: 5

        NerdIcon {
            icon: Audio.icon
        }
        StyledText {
            text: Audio.volumeStr
        }

        NerdIcon {
            visible: Audio.micMuted
            icon: Audio.micIcon
            Layout.leftMargin: 3
        }
    }
}
