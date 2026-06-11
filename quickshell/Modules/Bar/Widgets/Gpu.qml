import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: "󰢮"
    text: SystemMonitor.gpu + "%"
    visible: SystemMonitor.gpu >= 0
}
