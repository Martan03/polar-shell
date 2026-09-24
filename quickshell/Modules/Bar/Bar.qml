import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "Widgets"
import "../../Services"
import ".."
import "../ControlCenter"
import "../Calendar"
import "../Weather"
import "../SystemMonitor"

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

            implicitHeight: 33

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
                    onClicked: mediaPopup.toggle()

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

            CaptureIndicator {
                anchors.right: centerWidgets.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            RowLayout {
                id: centerWidgets

                spacing: 10
                anchors.centerIn: parent

                BarPill {
                    id: weatherPill
                    interactive: true
                    onClicked: weatherPopup.toggle()
                    visible: Weather.currentTemp !== "--"

                    WeatherPopup {
                        id: weatherPopup
                        visible: false
                        anchor.item: weatherPill
                        anchor.rect.x: (weatherPill.width - implicitWidth) / 2
                        anchor.rect.y: weatherPill.height
                    }

                    WeatherWidget {}
                }

                BarPill {
                    id: centerPill
                    interactive: true
                    onClicked: calendarPopup.toggle()

                    CalendarPopup {
                        id: calendarPopup
                        visible: false
                        anchor.item: centerPill
                        anchor.rect.x: (centerPill.width - implicitWidth) / 2
                        anchor.rect.y: centerPill.height
                    }

                    Clock {}
                }
            }

            RowLayout {
                spacing: 10
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                BarPill {
                    id: sysPill
                    interactive: true
                    onClicked: sysPopup.toggle()

                    SysPopup {
                        id: sysPopup
                        visible: false
                        anchor.item: sysPill
                        anchor.rect.x: (sysPill.width - implicitWidth) / 2
                        anchor.rect.y: sysPill.height
                    }

                    Cpu {}
                    Memory {}
                    Gpu {}
                }

                BarPill {
                    id: trayPill
                    interactive: true
                    onClicked: controlCenter.toggle()

                    ControlCenter {
                        id: controlCenter
                        visible: false
                        anchor.item: trayPill
                    }

                    Volume {}
                    Battery {}
                    SystemTray {}
                }
            }
        }
    }
}
