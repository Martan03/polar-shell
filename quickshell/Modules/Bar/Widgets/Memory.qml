import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: " "
    text: SystemMonitor.mem + "%"
    visible: SystemMonitor.mem >= 0
}
