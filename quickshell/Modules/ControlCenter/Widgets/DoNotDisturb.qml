import QtQuick
import "../Components"
import "../../../Services"

IconToggleButton {
    icon: Mako.isDnd ? "󰂛" : "󰂚"
    active: Mako.isDnd
    tooltipText: "Do Not Disturb"
    onClicked: Mako.toggle()
}
