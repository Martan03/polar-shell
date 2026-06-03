import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "Services"
import "Widgets"

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "powermenu"
    exclusionMode: ExclusionMode.Ignore

    focusable: GlobalState.activeMonitor === modelData.name

    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.5)
    visible: GlobalState.powerMenuOpen

    property int selected: 0
    property var items: [
        {
            icon: "󰤄",
            cmd: ["systemctl", "suspend"]
        },
        {
            icon: "󰐥",
            cmd: ["systemctl", "poweroff"]
        },
        {
            icon: "",
            cmd: ["systemctl", "reboot"]
        },
    ]

    property string uptime: "Loading..."
    Process {
        id: uptimeProcess
        command: ["uptime", "-p"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    root.uptime = this.text.replace("up", "").trim();
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: GlobalState.powerMenuVisible = false
    }

    Shortcut {
        sequences: ["Left", "h"]
        onActivated: {
            if (root.selected > 0)
                root.selected--;
        }
    }

    Shortcut {
        sequences: ["Right", "l"]
        onActivated: {
            if (root.selected < root.items.length - 1)
                root.selected++;
        }
    }

    Shortcut {
        sequences: ["Return", "Enter"]
        onActivated: {
            GlobalState.powerMenuVisible = false;
            actionProcess.command = root.items[root.selected].cmd;
            actionProcess.running = true;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: GlobalState.activeMonitor = modelData.name
        onClicked: GlobalState.powerMenuVisible = false
    }

    Process {
        id: actionProcess
    }

    onVisibleChanged: {
        if (visible) {
            uptimeProcess.running = true;
            root.selected = 0;
        }
    }

    ColumnLayout {
        visible: GlobalState.activeMonitor === modelData.name
        anchors.centerIn: parent
        spacing: 30

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            StyledText {
                text: "Uptime:"
                color: Theme.muted
            }

            StyledText {
                text: root.uptime
                font.bold: true
            }
        }

        RowLayout {
            spacing: 20

            Repeater {
                model: root.items

                Rectangle {
                    id: itemButton

                    implicitWidth: 120
                    implicitHeight: 120
                    radius: 20

                    property bool isSelected: index === root.selected
                    color: isSelected ? Theme.primary : Theme.surface

                    NerdIcon {
                        anchors.centerIn: parent
                        icon: modelData.icon
                        size: 32

                        color: itemButton.isSelected ? Theme.surface : Theme.primary
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onEntered: root.selected = index

                        onClicked: {
                            GlobalState.powerMenuVisible = false;
                            actionProcess.command = modelData.cmd;
                            actionProcess.running = true;
                        }
                    }
                }
            }
        }
    }
}
