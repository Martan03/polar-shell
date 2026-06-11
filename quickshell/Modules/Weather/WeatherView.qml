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
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            NerdIcon {
                icon: Weather.currentIcon
                Layout.alignment: Qt.AlignVCenter
                size: 40
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                StyledText {
                    text: Weather.currentTemp
                    font.pixelSize: 20
                    font.bold: true
                }

                StyledText {
                    text: Weather.currentDesc
                    color: Theme.muted
                    font.pixelSize: 12
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: 85
            orientation: ListView.Horizontal
            spacing: 15
            clip: true

            interactive: true
            boundsBehavior: Flickable.StopAtBounds

            model: Weather.hourlyForecast

            delegate: ColumnLayout {
                width: 45
                spacing: 6

                StyledText {
                    text: modelData.time
                    Layout.alignment: Qt.AlignHCenter
                    color: index === 0 ? Theme.primary : Theme.muted
                    font.pixelSize: 11
                }

                NerdIcon {
                    icon: modelData.icon
                    Layout.alignment: Qt.AlignHCenter
                    size: 18
                }

                StyledText {
                    text: modelData.temp
                    Layout.alignment: Qt.AlignHCenter
                    Layout.leftMargin: 4
                    font.bold: true
                }

                StyledText {
                    text: modelData.precip
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: 10
                    color: modelData.precip !== "" ? "#89b4fa" : "transparent"
                }
            }
        }
    }
}
