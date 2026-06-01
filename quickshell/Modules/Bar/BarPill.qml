import QtQuick
import QtQuick.Effects

import "../../Services"

Item {
    id: pillRoot

    property bool interactive: false
    signal clicked

    property int leftMargin: 15
    property int rightMargin: 15
    property int spacing: 10

    implicitWidth: contentRow.implicitWidth + leftMargin + rightMargin
    implicitHeight: 26

    default property alias content: contentRow.data

    HoverHandler {
        id: hover
        enabled: pillRoot.interactive
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        enabled: pillRoot.interactive
        onTapped: pillRoot.clicked()
    }

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
        radius: height / 2

        color: {
            if (pillRoot.interactive && hover.hovered) {
                return Theme.border;
            }
            return Theme.surface;
        }
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    Row {
        id: contentRow

        anchors.left: parent.left
        anchors.leftMargin: pillRoot.leftMargin
        anchors.verticalCenter: parent.verticalCenter
        spacing: pillRoot.spacing

        onChildrenChanged: {
            for (let i = 0; i < children.length; i++) {
                children[i].anchors.verticalCenter = contentRow.verticalCenter;
            }
        }
    }
}
