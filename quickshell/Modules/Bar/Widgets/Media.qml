import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

Item {
    id: root

    implicitWidth: contentLayout.implicitWidth
    implicitHeight: contentLayout.implicitHeight

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: mouse => {
            const player = Mpris.active;
            if (!player)
                return;

            if (mouse.button === Qt.LeftButton) {
                player.togglePlaying();
            } else if (mouse.button === Qt.MiddleButton && player.canGoPrevious) {
                player.previous();
            } else if (mouse.button === Qt.RightButton) {
                player.next();
            }
        }
    }

    RowLayout {
        id: contentLayout
        spacing: 10

        NerdIcon {
            icon: Mpris.icon
            size: 13
        }

        StyledText {
            text: Mpris.displayString

            Layout.maximumWidth: 300
            elide: Text.ElideRight
        }
    }
}
