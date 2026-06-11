import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: "󰢮"
    text: SysMonitor.gpu + "%"
    visible: SysMonitor.gpu >= 0
}
