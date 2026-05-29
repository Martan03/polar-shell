import QtQuick
import "../../../Services"
import "../../../Widgets"

Row {
    spacing: 5
    visible: SystemMonitor.cpu >= 0

    NerdIcon {
        icon: ""
    }
    StyledText {
        text: SystemMonitor.cpu + "%"
    }
}
