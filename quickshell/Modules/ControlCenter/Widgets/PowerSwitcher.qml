import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

Rectangle {
    id: root

    visible: PowerState.hasBattery

    implicitHeight: 60
    implicitWidth: 285
    radius: 12
    color: Theme.border

    Item {
        id: container
        anchors.fill: parent
        anchors.margins: 4

        Rectangle {
            id: highlight

            readonly property Item target: {
                if (PowerState.profile === "power-saver")
                    return saverSeg;
                if (PowerState.profile === "performance")
                    return boostSeg;
                return balancedSeg;
            }

            x: target.x
            y: target.y
            width: target.width
            height: target.height

            radius: 8
            color: Theme.primary

            Behavior on x {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutQuart
                }
            }
            Behavior on width {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutQuart
                }
            }
        }

        RowLayout {
            id: rowLayout
            anchors.fill: parent
            spacing: 4

            ProfileSegment {
                id: saverSeg
                profileId: "power-saver"
                icon: "󰌪"
                label: "Saver"
            }

            ProfileSegment {
                id: balancedSeg
                profileId: "balanced"
                icon: ""
                label: "Balanced"
            }

            ProfileSegment {
                id: boostSeg
                profileId: "performance"
                icon: "󰓅"
                label: "Boost"
            }
        }
    }

    component ProfileSegment: Item {
        id: segment
        required property string profileId
        required property string icon
        required property string label

        implicitWidth: innerRow.implicitWidth + 30
        Layout.fillWidth: true
        Layout.fillHeight: true

        property bool active: PowerState.profile === profileId

        RowLayout {
            id: innerRow
            anchors.centerIn: parent
            spacing: 6

            NerdIcon {
                icon: segment.icon

                color: segment.active ? Theme.surface : Theme.primary
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }

            StyledText {
                text: segment.label
                font.bold: segment.active
                font.pixelSize: 12

                color: segment.active ? Theme.surface : Theme.primary
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: PowerState.setProfile(segment.profileId)
        }
    }
}
