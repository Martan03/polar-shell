import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: ""
    text: SysMonitor.cpu + "%"
    visible: SysMonitor.cpu >= 0
}
