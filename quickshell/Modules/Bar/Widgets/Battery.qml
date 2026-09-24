import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: PowerState.icon
    text: PowerState.capacity + "%"
    visible: PowerState.capacity >= 0
}
