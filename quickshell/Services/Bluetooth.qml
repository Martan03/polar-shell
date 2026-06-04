pragma Singleton
import QtQuick
import Quickshell.Io

SmartPoller {
    id: root

    property bool hasDevice: false
    property bool isEnabled: false
    property string connectedName: ""

    onPollAction: pollProcess.running = true

    function toggle() {
        if (!hasDevice)
            return;

        let state = isEnabled ? "off" : "on";
        root.isEnabled = !root.isEnabled;

        toggleProcess.command = ["bluetoothctl", "power", state];
        toggleProcess.running = true;
    }

    function handlePoll(output) {
        const lines = output.split("\n");
        let parsingDevices = false;

        let hasDevice = false;
        let isEnabled = false;
        let connectedName = "";

        for (let line of lines) {
            if (line === "---") {
                parsingDevices = true;
                continue;
            }

            if (parsingDevices) {
                if (connectedName !== "")
                    continue;
                let match = line.match(/^Device\s(?:[0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}\s(.*)$/);
                if (match)
                    connectedName = match[1];
            } else {
                if (line.includes("Controller"))
                    hasDevice = true;
                if (line.includes("Powered: yes"))
                    isEnabled = true;
            }
        }

        root.hasDevice = hasDevice;
        root.isEnabled = isEnabled;
        root.connectedName = connectedName;
    }

    Process {
        id: pollProcess
        command: ["sh", "-c", "if command -v bluetoothctl >/dev/null 2>&1; then bluetoothctl show; echo '---'; bluetoothctl devices Connected; else echo 'CMD_MISSING'; fi"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text)
                    return;

                const output = this.text.trim();
                if (output === "CMD_MISSING") {
                    root.hasDevice = false;
                    root.timerEnabled = false;
                    return;
                }

                root.handlePoll(output);
            }
        }
    }

    Process {
        id: toggleProcess
        onExited: pollProcess.running = true
    }

    Component.onCompleted: pollProcess.running = true
}
