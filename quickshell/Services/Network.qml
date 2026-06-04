pragma Singleton
import QtQuick
import Quickshell.Io

SmartPoller {
    id: root

    property string activeType: "none"
    property string activeName: "Disconnected"
    property bool isWifiEnabled: false
    property bool hasWifiDevice: false

    onPollAction: pollProcess.running = true

    function toggleWifi() {
        if (!hasWifiDevice)
            return;

        let state = isWifiEnabled ? "off" : "on";
        root.isWifiEnabled = !root.isWifiEnabled;

        toggleProcess.command = ["nmcli", "radio", "wifi", state];
        toggleProcess.running = true;
    }

    Process {
        id: pollProcess
        command: ["sh", "-c", "nmcli -t -f TYPE,CONNECTION,STATE dev status && nmcli -t radio wifi"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text)
                    return;

                let lines = this.text.trim().split("\n");
                let foundActive = false;
                let foundWifi = false;

                for (let line of lines) {
                    if (line === "enabled" || line === "disabled") {
                        root.isWifiEnabled = line === "enabled";
                        continue;
                    }

                    let match = line.match(/^([^:]+):(.*):([^:]+)$/);
                    if (match) {
                        const type = match[1];
                        if (type === "wifi")
                            foundWifi = true;

                        if (match[3] === "connected" && !foundActive) {
                            root.activeType = type;
                            root.activeName = match[2].replace(/\\:/g, ":");
                            foundActive = true;
                        }
                    }
                }

                if (!foundActive) {
                    root.activeType = "none";
                    root.activeName = "Disconnected";
                }
                root.hasWifiDevice = foundWifi;
            }
        }
    }

    Process {
        id: toggleProcess
        onExited: pollProcess.running = true
    }

    Component.onCompleted: pollProcess.running = true
}
