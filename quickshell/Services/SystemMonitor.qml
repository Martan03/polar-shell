pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpu: -1
    property int mem: -1
    property int gpu: -1

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
        command: ["bash", "-c", "top -b -n1 | awk '/%Cpu/ {print 100 - $8}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(this.text.trim());
                if (!isNaN(val))
                    root.cpu = val;
            }
        }
    }

    Process {
        id: memProc
        command: ["bash", "-c", "free | awk '/^Mem/ {printf \"%.0f\", $3/$2 * 100}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(this.text.trim());
                if (!isNaN(val))
                    root.mem = val;
            }
        }
    }

    Process {
        id: gpuProc
        command: ["bash", "-c", "if command -v nvidia-smi &> /dev/null; then nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null; elif ls /sys/class/drm/card*/device/gpu_busy_percent &> /dev/null; then cat /sys/class/drm/card*/device/gpu_busy_percent | head -n 1; else echo -1; fi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(this.text.trim());
                if (!isNaN(val))
                    root.gpu = val;
            }
        }
    }
}
