import QtQuick
import QtQuick.Layouts
import "../../../Services"
import "../../../Widgets"

RowLayout {
    spacing: 5
    visible: SystemMonitor.gpu >= 0

    NerdIcon {
        icon: "󰢮"
        size: 18
    }
    StyledText {
        text: SystemMonitor.gpu + "%"
    }
}
