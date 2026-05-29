import QtQuick
import QtQuick.Effects

import "../../Services"

Item {
    id: pillRoot

    implicitWidth: contentRow.implicitWidth + 30
    implicitHeight: contentRow.implicitHeight + 10

    default property alias content: contentRow.data

    Rectangle {
        id: borderRect
        color: Theme.primary
        radius: height / 2

        anchors.fill: parent
        anchors.topMargin: -1
        anchors.bottomMargin: 1
        anchors.leftMargin: 1
        anchors.rightMargin: 1

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#66000000"
            shadowBlur: 0.8
            shadowVerticalOffset: 3
            shadowHorizontalOffset: 0
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.surface
        radius: height / 2
    }

    Row {
        id: contentRow

        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        onChildrenChanged: {
            for (let i = 0; i < children.length; i++) {
                children[i].anchors.verticalCenter = contentRow.verticalCenter;
            }
        }
    }
}
