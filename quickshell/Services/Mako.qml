pragma Singleton
import QtQuick
import Quickshell.Io

SmartPoller {
    id: root

    property bool isDnd: false

    onPollAction: {
        pollProcess.running = true;
    }

    function toggle() {
        let action = root.isDnd ? "-r" : "-a";
        toggleProcess.command = ["makoctl", "mode", action, "dnd"];
        toggleProcess.running = true;

        root.isDnd = !root.isDnd;
        pollProcess.running = true;
    }

    Process {
        id: pollProcess
        command: ["makoctl", "mode"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text)
                    return;
                root.isDnd = this.text.includes("dnd");
            }
        }
    }

    Process {
        id: toggleProcess
        onExited: pollProcess.running = true
    }

    Component.onCompleted: pollProcess.running = true
}
