import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

Item {
    id: root

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

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
