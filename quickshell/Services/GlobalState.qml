pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property bool powerMenuVisible: false
    property bool powerMenuOpen: false
    property string activeMonitor: ""

    onPowerMenuVisibleChanged: {
        if (powerMenuVisible) {
            activeMonitorProcess.running = true;
        } else {
            powerMenuOpen = false;
        }
    }

    Process {
        id: activeMonitorProcess
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    try {
                        const data = JSON.parse(this.text);
                        root.activeMonitor = data.monitor;
                    } catch (e) {}
                }
                root.powerMenuOpen = true;
            }
        }
    }
}
