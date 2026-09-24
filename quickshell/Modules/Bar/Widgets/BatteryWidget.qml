import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: Battery.icon
    text: Battery.capacity + "%"
    visible: Battery.capacity >= 0
}
