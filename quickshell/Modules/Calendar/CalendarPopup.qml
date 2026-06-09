import QtQuick
import QtQuick.Layouts
import "../../Widgets"
import "Widgets"

Popup {
    id: root

    implicitWidth: 350
    implicitHeight: content.implicitHeight + 40

    ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Weather {
            Layout.fillWidth: true
        }
        Calendar {
            Layout.fillWidth: true
        }
    }
}
