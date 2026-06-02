// To make this work on external monitors, make sure to install `ddcutil`.

import QtQuick
import QtQuick.Window
import Quickshell.Io
import "../Components"

ControlSlider {
    id: root

    icon: "󰃠"
    value: 0.5

    property string backend: "internal"
    property string device: ""
    property real pendingValue: -1

    function processQueue() {
        if (writeProcess.running || root.pendingValue < 0)
            return;

        const percent = Math.max(1, Math.round(root.pendingValue * 100));

        if (root.backend === "internal") {
            let cmd = ["brightnessctl", "--class=backlight"];
            if (root.device !== "")
                cmd.push(`--device=${root.device}`);
            cmd.push("set", `${percent}%`);
            writeProcess.command = cmd;
        } else {
            let num = root.device !== "" ? root.device : "1";
            writeProcess.command = ["ddcutil", "--display", num, "setvcp", "10", percent.toString()];
        }

        root.pendingValue = -1;
        writeProcess.running = true;
    }

    onValChanged: val => {
        root.value = val;
        root.pendingValue = val;
        root.processQueue();
    }

    Process {
        id: readProcess
        command: {
            if (root.backend === "internal") {
                let cmd = ["brightnessctl", "--class=backlight", "-m"];
                if (root.device !== "")
                    cmd.splice(1, 0, `--device=${root.device}`);
                return cmd;
            } else {
                const num = root.device !== "" ? root.device : "1";
                return ["ddcutil", "--display", num, "getvcp", "10", "--terse"];
            }
        }
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text)
                    return;

                if (root.backend === "internal") {
                    const parts = this.text.trim().split(",");
                    if (parts.length >= 4) {
                        const percent = parts[3].replace("%", "");
                        root.value = parseFloat(percent) / 100;
                    }
                } else {
                    const parts = this.text.trim().split(" ");
                    if (parts.length >= 4 && parts[1] === "10") {
                        root.value = parseFloat(parts[3]) / 100.0;
                    }
                }
            }
        }
    }

    Process {
        id: writeProcess
        onExited: root.processQueue()
    }

    Timer {
        interval: root.backend === "internal" ? 2000 : 10000
        repeat: true
        running: root.Window.window ? root.Window.window.visible : false
        onTriggered: {
            if (!root.isDragging && !writeProcess.running && root.pendingValue == -1)
                readProcess.running = true;
        }
    }
}
