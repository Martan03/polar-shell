import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../Services"
import "../../Widgets"
import "Widgets"

Popup {
    id: root

    anchorEdges: Qt.RightEdge | Qt.BottomEdge
    implicitWidth: 400
    implicitHeight: content.implicitHeight + 40

    ColumnLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20

        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Rectangle {
                implicitWidth: 30
                implicitHeight: 30
                radius: width / 2
                color: Theme.primary

                StyledText {
                    anchors.centerIn: parent
                    text: ""
                    color: Theme.surface
                }
            }

            StyledText {
                Layout.fillWidth: true
                text: Quickshell.env("USER")
                // font.bold: true
                font.pixelSize: 15
            }

            IconButton {
                icon: ""
                size: 40
                onClicked: {
                    root.visible = false;
                    GlobalState.powerMenuVisible = true;
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Connection {
                Layout.fillWidth: true
            }

            Bluetooth {
                Layout.fillWidth: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 15

            BrightnessSlider {
                Layout.fillWidth: true
                backend: "external"
                device: "1"
            }

            Audio {
                Layout.fillWidth: true
            }

            Audio {
                Layout.fillWidth: true
                type: "source"
            }
        }
    }
}
