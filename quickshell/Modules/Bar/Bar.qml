import QtQuick
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
            }

            BarPill {
                horMargin: 8
                verMargin: 5

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                Workspaces {
                    screen: barWindow.modelData
                    hyprMonitor: Hyprland.monitorFor(barWindow.modelData)
                }
            }

            BarPill {
                anchors.centerIn: parent

                Clock {}
            }

            BarPill {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Volume {}
            }
        }
    }
}
