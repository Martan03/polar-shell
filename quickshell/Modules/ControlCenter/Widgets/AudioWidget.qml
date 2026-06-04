import QtQuick

Item {
    id: root

    property string type: "sink"
    property bool isExpanded: false

    implicitHeight: slider.implicitHeight + clipContainer.height

    VolumeSlider {
        id: slider
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        type: root.type
        onRightClicked: root.isExpanded = !root.isExpanded
    }

    Item {
        id: clipContainer
        anchors.top: slider.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        clip: true
        height: root.isExpanded ? audioList.implicitHeight + 15 : 0
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCubic
            }
        }

        AudioList {
            id: audioList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 15

            type: root.type
            width: parent.width

            opacity: root.isExpanded ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutCubic
                }
            }
        }
    }
}
