import QtQuick

import "../Services"

Item {
    id: root

    property string icon: ""
    property int size: 13
    property color color: Theme.primary

    width: iconText.implicitWidth
    height: iconText.implicitHeight

    Text {
        id: iconText
        anchors.centerIn: parent
        text: parent.icon
        color: parent.color

        font.pixelSize: parent.size
        font.family: Theme.font
        verticalAlignment: Text.AlignVCenter
    }
}
