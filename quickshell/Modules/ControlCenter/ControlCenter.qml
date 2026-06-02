import QtQuick
import QtQuick.Layouts
import "../../Services"
import "../../Widgets"
import "Components"
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

            ToggleButton {
                icon: "󰤨"
                label: "Wi-Fi"
                sublabel: "MyWifiName"
                Layout.fillWidth: true
                active: true
                onClicked: active = !active
            }

            ToggleButton {
                icon: "󰂯"
                label: "Bluetooth"
                Layout.fillWidth: true
                active: false
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 15

            VolumeSlider {
                Layout.fillWidth: true
            }

            BrightnessSlider {
                Layout.fillWidth: true
                backend: "external"
                device: "1"
            }
        }

        // TODO: make it actually work :)
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Repeater {
                model: ["", "󰍃", "󰜉", "󰐥"]
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    radius: 8
                    color: Theme.border
                    StyledText {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 18
                    }
                }
            }
        }
    }
}
