import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: " "
    text: SysMonitor.mem + "%"
    visible: SysMonitor.mem >= 0
}
