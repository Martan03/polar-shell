//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import "Services"
import qs.Modules.Bar

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens
        PowerMenu {}
    }

    Bar {}

    IpcHandler {
        target: "myshell"

        function togglePowermenu(): void {
            GlobalState.powerMenuVisible = !GlobalState.powerMenuVisible;
        }
    }

    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
    }
}
