import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "Widgets"
import "../../Services"
import ".."
import "../ControlCenter"

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
                    leftMargin: 4
                    rightMargin: 4

                    Workspaces {
                        screen: barWindow.modelData
                        hyprMonitor: Hyprland.monitorFor(barWindow.modelData)
                    }
                }

                BarPill {
                    id: mediaPill
                    interactive: true
                    leftMargin: 6
                    onClicked: mediaPopup.visible = !mediaPopup.visible

                    MediaPopup {
                        id: mediaPopup
                        visible: false
                        anchor.item: mediaPill
                    }

                    Media {
                        TapHandler {
                            acceptedButtons: Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onTapped: MprisCtl.active?.next()
                        }

                        TapHandler {
                            acceptedButtons: Qt.MiddleButton
                            onTapped: MprisCtl.active?.previous()
                        }
                    }
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
                    id: trayPill
                    interactive: true
                    onClicked: controlCenter.visible = !controlCenter.visible

                    ControlCenter {
                        id: controlCenter
                        visible: false
                        anchor.item: trayPill
                    }

                    Volume {}
                    SystemTray {}
                }
            }
        }
    }
}
