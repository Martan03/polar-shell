pragma Singleton
import QtQuick
import Quickshell.Io

SmartPoller {
    id: root

    property bool isActive: false
    property string ipAddress: "Disconnected"
    property string interfaceName: "FIT"

    onPollAction: pollProcess.running = true

    function toggle() {
        const action = root.isActive ? "down" : "up";
        toggleProcess.command = ["nmcli", "connection", action, root.interfaceName];
        toggleProcess.running = true;

        root.isActive = !root.isActive;
        root.ipAddress = root.isActive ? "Connecting..." : "Disconnected";
    }

    Process {
        id: pollProcess
        command: ["sh", "-c", `DEV=$(nmcli -g NAME,DEVICE connection show --active | grep "^${root.interfaceName}:" | cut -d: -f2); [ -n "$DEV" ] && ip -brief address show "$DEV"`]
        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text) {
                    root.isActive = false;
                    root.ipAddress = "Disconnected";
                    return;
                }

                const parts = this.text.trim().split(/\s+/);
                if (parts.length >= 3) {
                    root.isActive = true;
                    root.ipAddress = parts[2];
                }
            }
        }
    }

    Process {
        id: toggleProcess
        onExited: pollProcess.running = true
    }

    Component.onCompleted: pollProcess.running = true
}
