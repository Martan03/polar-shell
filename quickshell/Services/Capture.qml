pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    readonly property int stateIdle: 0
    readonly property int stateStarting: 1
    readonly property int stateRecording: 2
    readonly property int stateStopping: 3

    property int captureState: root.stateIdle

    property bool isRecording: root.captureState === root.stateRecording
    property bool isBusy: root.captureState === root.stateStarting || root.captureState === root.stateStopping

    property string targetMonitor: "auto"
    property string outputFormat: "mp4"
    property bool cleanDesktop: false
    property int countdown: 2

    property string scriptPath: Qt.resolvedUrl("../scripts/capture.sh").toString().replace("file://", "")

    function toggle() {
        if (root.isBusy)
            return;

        if (root.isRecording) {
            stop();
        } else {
            start();
        }
    }

    function start() {
        let cmd = ["bash", root.scriptPath, "start", "-f", root.outputFormat];
        if (root.targetMonitor !== "auto") {
            cmd.push("-m", root.targetMonitor);
        }
        if (root.cleanDesktop) {
            cmd.push("-c");
        }
        if (root.countdown > 0) {
            cmd.push("-d", root.countdown);
        }

        root.captureState = root.stateStarting;
        startProcess.command = cmd;
        startProcess.running = true;
    }

    function stop() {
        root.captureState = root.stateStopping;
        stopProcess.running = true;
    }

    Process {
        id: startProcess
        onExited: (code, status) => {
            if (code === 0) {
                root.captureState = root.stateRecording;
            } else {
                console.error(`Start Capture Error: ${code} - ${status}`);
                root.captureState = root.stateIdle;
            }
        }
    }

    Process {
        id: stopProcess
        command: ["bash", root.scriptPath, "stop"]
        onExited: (code, status) => {
            root.captureState = root.stateIdle;
            if (code !== 0) {
                console.error(`Stop Capture Error: ${code} - ${status}`);
            }
        }
    }

    Process {
        id: checkRunning
        command: ["bash", root.scriptPath, "running"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() === "true") {
                    root.captureState = root.stateRecording;
                }
            }
        }
    }

    Component.onCompleted: {
        checkRunning.running = true;
    }
}
