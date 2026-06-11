import QtQuick
import QtQuick.Layouts
import "../../Widgets"

Popup {
    id: root

    implicitWidth: 260
    implicitHeight: contentLayout.implicitHeight + 40

    ColumnLayout {
        id: contentLayout

        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        SysView {
            Layout.fillWidth: true
        }
    }
}
