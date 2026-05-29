import QtQuick
import Quickshell

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
