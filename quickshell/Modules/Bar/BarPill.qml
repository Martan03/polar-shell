import QtQuick
import QtQuick.Effects

import "../../Services"

Item {
    id: pillRoot

    property int horMargin: 30
    property int verMargin: 10

    property int spacing: 10

    implicitWidth: contentRow.implicitWidth + horMargin
    implicitHeight: 26

    default property alias content: contentRow.data

    Rectangle {
        id: borderRect
        color: Theme.primary
        radius: height / 2

        anchors.fill: parent
        anchors.topMargin: -1
        anchors.bottomMargin: 1
        anchors.leftMargin: 0.5
        anchors.rightMargin: 0.5

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
        anchors.leftMargin: pillRoot.horMargin / 2
        anchors.verticalCenter: parent.verticalCenter
        spacing: pillRoot.spacing

        onChildrenChanged: {
            for (let i = 0; i < children.length; i++) {
                children[i].anchors.verticalCenter = contentRow.verticalCenter;
            }
        }
    }
}
