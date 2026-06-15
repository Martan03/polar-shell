import QtQuick
import QtQuick.Layouts
import "../../Widgets"

Popup {
    id: root

    implicitWidth: 400
    implicitHeight: content.implicitHeight + 40 + popupGap

    ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        WeatherView {
            Layout.fillWidth: true
        }
    }
}
