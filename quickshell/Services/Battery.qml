pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property int capacity: 100
    property string status: "Unknown"
    property string profile: "balanced"

    readonly property string icon: {
        let charging = status === "Charging";
        if (capacity <= 10)
            return charging ? "󰢜" : "󰁺";
        if (capacity <= 20)
            return charging ? "󰂆" : "󰁻";
        if (capacity <= 30)
            return charging ? "󰂇" : "󰁼";
        if (capacity <= 40)
            return charging ? "󰂈" : "󰁽";
        if (capacity <= 50)
            return charging ? "󰢝" : "󰁾";
        if (capacity <= 60)
            return charging ? "󰂉" : "󰁿";
        if (capacity <= 70)
            return charging ? "󰢞" : "󰂀";
        if (capacity <= 80)
            return charging ? "󰂊" : "󰂁";
        if (capacity <= 90)
            return charging ? "󰂋" : "󰂂";
        return charging ? "󰂅" : "󰁹";
    }

    function setProfile(profile) {
        setProfileProcess.command = ["powerprofilectl", "set", profile];
        setProfileProcess.running = true;
        root.activeProfile = profile;
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            batteryProcess.running = true;
            profileProcess.running = true;
        }
    }

    Process {
        id: batteryProcess
        command: ["bash", "-c", "echo $(cat /sys/class/power_supply/BAT*/capacity | head -n 1) $(cat /sys/class/power_supply/BAT*/status | head -n 1)"]
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split(" ");
                if (parts.length >= 2) {
                    root.capacity = parseInt(parts[0]);
                    root.status = parts[1];
                }
            }
        }
    }

    Process {
        id: profileProcess
        command: ["powerprofilesctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text) {
                    root.profile = this.text.trim();
                }
            }
        }
    }

    Process {
        id: setProfileProcess
    }
}
