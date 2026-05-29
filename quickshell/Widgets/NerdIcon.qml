import QtQuick

import "../Services"

Item {
    id: root

    property string icon: ""
    property int size: 13

    width: iconText.implicitWidth
    height: iconText.implicitHeight

    Text {
        id: iconText
        anchors.centerIn: parent
        text: parent.icon
        color: Theme.primary

        font.pixelSize: parent.size
        font.family: Theme.font
        verticalAlignment: Text.AlignVCenter
    }
}
