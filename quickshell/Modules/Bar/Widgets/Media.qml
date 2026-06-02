import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

Item {
    id: root

    implicitWidth: contentLayout.implicitWidth
    implicitHeight: contentLayout.implicitHeight

    RowLayout {
        id: contentLayout
        spacing: 10

        Rectangle {
            implicitWidth: 18
            implicitHeight: 18
            radius: 9

            color: hover.hovered ? Theme.primaryHover : Theme.primary
            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }

            NerdIcon {
                anchors.centerIn: parent
                icon: MprisCtl.icon
                color: Theme.border
                size: 10
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: MprisCtl.active?.togglePlaying()
            }

            HoverHandler {
                id: hover
            }
        }

        StyledText {
            text: MprisCtl.displayString

            Layout.maximumWidth: 300
            elide: Text.ElideRight
        }
    }
}
