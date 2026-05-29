pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    PwObjectTracker {
        objects: {
            let targets = [];
            if (root.sink)
                targets.push(root.sink);
            if (root.source)
                targets.push(root.source);
            return targets;
        }
    }

    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property string volumeStr: Math.round(volume * 100) + "%"
    readonly property bool muted: sink?.audio?.muted ?? false

    readonly property string icon: {
        if (muted)
            return "󰝟";
        if (volume > 0.6)
            return "";
        if (volume > 0.3)
            return "";
        return "";
    }

    readonly property real micVolume: source?.audio?.volume ?? 0.0
    readonly property string micVolumeStr: Math.round(volume * 100) + "%"
    readonly property bool micMuted: source?.audio?.muted ?? false

    readonly property string micIcon: micMuted ? "󰍭" : "󰍬"
}
