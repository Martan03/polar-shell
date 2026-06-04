import QtQuick
import "../../../Services"
import "../Components"

ToggleButton {
    icon: Bluetooth.isEnabled ? "󰂯" : "󰂲"
    label: "Bluetooth"
    sublabel: Bluetooth.isEnabled ? (Bluetooth.connectedName !== "" ? Bluetooth.connectedName : "Disconnected") : "Off"

    active: Bluetooth.isEnabled
    enabled: Bluetooth.hasDevice
    opacity: enabled ? 1.0 : 0.5

    onClicked: {
        if (Bluetooth.hasDevice) {
            Bluetooth.toggle();
        }
    }
}
