import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../../../Services"
import "../../../Widgets"

Item {
    id: root

    required property var screen
    required property var hyprMonitor

    property var monitorDefaults: {
        "DP-3": [1, 2, 3],
        "DVI-D-1": [4, 5, 6]
    }

    readonly property var persistentIds: monitorDefaults[screen.name] || []

    property var _updateTrigger: [hyprMonitor ? hyprMonitor.activeWorkspace : null, Hyprland.workspaces]
    property var workspaceModel: {
        let trigger = _updateTrigger;
        let list = [];
        if (!screen || !hyprMonitor)
            return list;

        let activeId = hyprMonitor.activeWorkspace ? hyprMonitor.activeWorkspace.id : -1;
        let added = new Set();

        for (const wid of persistentIds) {
            let exists = false;
            let isActive = (wid === activeId);

            for (let i = 0; i < Hyprland.workspaces.length; i++) {
                const w = Hyprland.workspaces[i];
                if (w.id === wid) {
                    exists = true;
                    break;
                }
            }

            list.push({
                id: wid,
                exists: exists,
                active: isActive
            });
            added.add(wid);
        }

        for (let i = 0; i < Hyprland.workspaces.length; i++) {
            const w = Hyprland.workspaces[i];
            if (w.monitor && w.monitor.name === hyprMonitor.name && w.id > 0 && !added.has(w.id)) {
                list.push({
                    id: w.id,
                    exists: true,
                    active: (w.id === activeId)
                });
                added.add(w.id);
            }
        }

        if (activeId > 0 && !added.has(activeId)) {
            list.push({
                id: activeId,
                exists: true,
                active: true
            });
            added.add(activeId);
        }

        list.sort((a, b) => a.id - b.id);
        return list;
    }

    implicitWidth: contentLayout.implicitWidth
    implicitHeight: contentLayout.implicitHeight

    Item {
        anchors.fill: contentLayout

        Rectangle {
            id: activeIndicator
            width: 20
            height: 20
            radius: 10
            color: Theme.primary

            x: 0

            Behavior on x {
                SpringAnimation {
                    spring: 25.0
                    damping: 1.2
                }
            }
        }
    }

    RowLayout {
        id: contentLayout
        spacing: 2

        Repeater {
            model: root.workspaceModel

            Item {
                id: workspaceItem

                implicitWidth: 20
                implicitHeight: 20

                onXChanged: {
                    if (modelData.active) {
                        activeIndicator.x = workspaceItem.x;
                    }
                }

                Component.onCompleted: {
                    if (modelData.active) {
                        Qt.callLater(function () {
                            activeIndicator.x = workspaceItem.x;
                        });
                    }
                }

                HoverHandler {
                    id: hover
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: {
                        if (hover.hovered && !modelData.active) {
                            return Theme.border;
                        }
                        return "transparent";
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                StyledText {
                    anchors.centerIn: parent
                    text: modelData.id

                    color: {
                        if (modelData.active)
                            return Theme.surface;
                        if (modelData.exists)
                            return Theme.foreground;
                        return Theme.muted;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${modelData.id} })`);
                    }
                }
            }
        }
    }
}
