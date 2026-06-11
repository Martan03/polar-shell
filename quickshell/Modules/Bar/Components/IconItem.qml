import QtQuick
import "../../../Widgets"

Row {
    id: root

    required property string icon
    required property string text

    spacing: 5

    NerdIcon {
        icon: root.icon
    }
    StyledText {
        text: root.text
    }
}
