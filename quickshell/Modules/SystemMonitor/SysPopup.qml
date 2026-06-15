import QtQuick
import QtQuick.Layouts
import "../../Widgets"
import "../../Services"

Popup {
    id: root

    implicitWidth: 260
    implicitHeight: contentLayout.implicitHeight + 40 + popupGap

    onVisibleChanged: SysMonitor.fetchApps = root.visible

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
