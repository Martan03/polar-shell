import QtQuick
import "../Components"
import "../../../Services"

IconToggleButton {
    icon: "󰖂"
    active: Vpn.isActive
    tooltipText: "VPN"

    onClicked: Vpn.toggle()
}
