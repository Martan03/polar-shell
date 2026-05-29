import QtQuick

import "../Services"

Item {
    id: root

    property string icon: ""
    property int size: 25

    width: iconText.implicitWidth
    height: 14

    Text {
        id: iconText
        anchors.centerIn: parent
        text: parent.icon
        color: Theme.primary
        font.pixelSize: parent.size
        verticalAlignment: Text.AlignVCenter
    }
}
