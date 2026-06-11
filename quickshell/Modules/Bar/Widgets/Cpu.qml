import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: ""
    text: SystemMonitor.cpu + "%"
    visible: SystemMonitor.cpu >= 0
}
