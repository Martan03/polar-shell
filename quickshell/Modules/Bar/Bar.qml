import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "Widgets"

Scope {
    id: bar

    SystemClock {
        id: barClock
        precision: SystemClock.Seconds
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow

            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            margins {
                right: 5
                left: 5
                top: 3
            }

            RowLayout {
                spacing: 10
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                BarPill {
                    horMargin: 8
                    verMargin: 5

                    Workspaces {
                        screen: barWindow.modelData
                        hyprMonitor: Hyprland.monitorFor(barWindow.modelData)
                    }
                }

                BarPill {
                    interactive: true
                    Media {}
                }
            }

            BarPill {
                anchors.centerIn: parent

                Clock {}
            }

            RowLayout {
                spacing: 10
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                BarPill {
                    Cpu {}
                    Memory {}
                    Gpu {}
                }

                BarPill {
                    interactive: true
                    Volume {}
                }
            }
        }
    }
}
