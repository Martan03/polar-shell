import QtQuick
import "../Components"
import "../../../Services"

IconToggleButton {
    icon: Mako.isDnd ? "󰂛" : "󰂚"
    active: Mako.isDnd
    onClicked: Mako.toggle()
}
