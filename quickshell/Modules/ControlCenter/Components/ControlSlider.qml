import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

Item {
    id: root

    required property string icon
    property real iconSize: 16
    property real iconButtonSize: 32

    property real value: 0.0

    property int barHeight: 8
    property color trackColor: Theme.border
    property color fillColor: Theme.primary
    property color hoverColor: Theme.primaryHover

    property alias isDragging: mouseArea.pressed

    signal valChanged(real value)
    signal iconClicked

    implicitHeight: Math.max(barHeight + 8, iconButtonSize)

    RowLayout {
        anchors.fill: parent
        spacing: 10

        IconButton {
            icon: root.icon
            iconSize: root.iconSize
            size: root.iconButtonSize
            onClicked: root.iconClicked()
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                width: parent.width
                height: root.barHeight
                anchors.verticalCenter: parent.verticalCenter
                color: root.trackColor
                radius: height / 2
            }

            Rectangle {
                width: Math.max(0, Math.min(parent.width, parent.width * root.value))
                height: root.barHeight
                anchors.verticalCenter: parent.verticalCenter
                radius: height / 2

                color: mouseArea.containsMouse ? root.hoverColor : root.fillColor
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Behavior on width {
                    enabled: !mouseArea.pressed
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Rectangle {
                width: root.barHeight + 8
                height: root.barHeight + 8
                x: Math.max(0, parent.width * root.value - width)
                radius: height / 2

                anchors.verticalCenter: parent.verticalCenter
                color: mouseArea.containsMouse ? root.hoverColor : root.fillColor
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                function updateValue(x) {
                    root.valChanged(Math.max(0, Math.min(1, x / width)));
                }

                onPressed: mouse => updateValue(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        updateValue(mouse.x);
                }
            }
        }
    }
}
