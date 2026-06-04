import QtQuick
import "../../../Services"
import "../Components"

ToggleButton {
    icon: Network.activeType === "ethernet" ? "󰈀" : (Network.activeType === "wifi" ? "󰤨" : "󰤭")
    label: Network.activeType === "ethernet" ? "Ethernet" : "Wi-Fi"
    sublabel: Network.activeName

    active: Network.isWifiEnabled || Network.activeType === "ethernet"
    enabled: Network.hasWifiDevice || Network.activeType === "ethernet"
    opacity: enabled ? 1.0 : 0.5

    onClicked: {
        if (Network.hasWifiDevice) {
            Network.toggleWifi();
        }
    }
}
