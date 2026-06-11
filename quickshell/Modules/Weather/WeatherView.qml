import QtQuick
import QtQuick.Layouts
import "../../Widgets"
import "../../Services"

Item {
    id: root
    implicitHeight: content.implicitHeight

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: 15

        RowLayout {
            Layout.fillWidth: true

            RowLayout {
                spacing: 15

                NerdIcon {
                    icon: Weather.currentIcon
                    size: 52
                    color: Theme.primary
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    spacing: -3

                    StyledText {
                        text: Weather.currentTemp
                        font.pixelSize: 32
                        font.bold: true
                    }

                    StyledText {
                        text: Weather.currentDesc
                        color: Theme.muted
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                spacing: 8

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 8
                    NerdIcon {
                        icon: "󰔏"
                        size: 14
                        color: Theme.muted
                    }
                    StyledText {
                        text: Weather.currentFeelsLike
                        font.pixelSize: 13
                        font.bold: true
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 8
                    NerdIcon {
                        icon: "󰖝"
                        size: 14
                        color: Theme.muted
                    }
                    StyledText {
                        text: Weather.currentWind
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Theme.border
        }

        WeatherTimeline {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
        }
    }
}
