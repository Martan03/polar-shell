import QtQuick
import QtQuick.Layouts
import "../../Widgets"

Popup {
    id: root

    implicitWidth: 350
    implicitHeight: content.implicitHeight + 40 + popupGap

    ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 20

        CalendarView {
            Layout.fillWidth: true
        }
    }
}
