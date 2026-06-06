import QtQuick
import Quickshell.Io
import "../Components"

IconToggleButton {
    id: root

    icon: "󰈋"
    active: false
    tooltipText: "Color Picker"

    signal requestHide

    Process {
        id: pickerProcess
        command: ["sh", "-c", "sleep 0.2 && hyprpicker -a"]
    }

    onClicked: {
        root.requestHide();
        pickerProcess.running = true;
    }
}
