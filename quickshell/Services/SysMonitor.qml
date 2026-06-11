pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpu: -1
    property int mem: -1
    property int gpu: -1

    property var cpuHistory: []
    property var memHistory: []
    property var gpuHistory: []

    property var cpuApps: []
    property var memApps: []
    property var gpuApps: []

    readonly property int maxHistoryLen: 30

    readonly property var metrics: {
        "cpu": {
            setVal: val => root.cpu = val,
            getHist: () => root.cpuHistory,
            setHist: hist => root.cpuHistory = hist,
            setApps: apps => root.cpuApps = apps
        },
        "mem": {
            setVal: val => root.mem = val,
            getHist: () => root.memHistory,
            setHist: hist => root.memHistory = hist,
            setApps: apps => root.memApps = apps
        },
        "gpu": {
            setVal: val => root.gpu = val,
            getHist: () => root.gpuHistory,
            setHist: hist => root.gpuHistory = hist,
            setApps: apps => root.gpuApps = apps
        }
    }

    function handleStream(target, text) {
        const lines = text.trim().split("\n");
        if (lines.length === 0)
            return;

        const metrics = root.metrics[target];
        if (!metrics)
            return;

        const val = parseInt(lines[0]);
        if (!isNaN(val)) {
            metrics.setVal(val);

            let history = [...metrics.getHist()];
            history.push(val);
            if (history.length > root.maxHistoryLen) {
                history.shift();
            }
            metrics.setHist(history);
        }

        let apps = [];
        for (let i = 1; i < lines.length; i++) {
            const parts = lines[i].trim().split(/\s+/);
            if (parts.length >= 2) {
                const usage = parts.pop();
                apps.push({
                    name: parts.join(" "),
                    usage: parseFloat(usage).toFixed(1) + "%"
                });
            }
        }
        metrics.setApps(apps);
    }

    Timer {
        id: pollTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            gpuProc.running = true;
        }
    }

    Component.onCompleted: pollTimer.triggered()

    Process {
        id: cpuProc
        command: ["bash", "-c", "top -b -n1 | awk '/%Cpu/ {print 100 - $8}'; ps -eo comm,%cpu --sort=-%cpu | head -n 6 | tail -n +2"]
        stdout: StdioCollector {
            onStreamFinished: root.handleStream("cpu", this.text)
        }
    }

    Process {
        id: memProc
        command: ["bash", "-c", "free | awk '/^Mem/ {printf \"%.0f\\n\", $3/$2 * 100}'; ps -eo comm,%mem --sort=-%mem | head -n 6 | tail -n +2"]
        stdout: StdioCollector {
            onStreamFinished: root.handleStream("mem", this.text)
        }
    }

    Process {
        id: gpuProc
        command: ["bash", "-c", "if command -v nvidia-smi &> /dev/null; then nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null; elif ls /sys/class/drm/card*/device/gpu_busy_percent &> /dev/null; then cat /sys/class/drm/card*/device/gpu_busy_percent | head -n 1; else echo -1; fi"]
        stdout: StdioCollector {
            onStreamFinished: root.handleStream("gpu", this.text)
        }
    }
}
