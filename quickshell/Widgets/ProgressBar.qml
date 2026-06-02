import QtQuick
import Quickshell.Services.Mpris
import "../Services"

Item {
    id: root

    property MprisPlayer player: null

    property int barHeight: 4
    property color trackColor: Theme.border
    property color fillColor: Theme.primary

    readonly property real stableLen: MprisCtl.activeStableLen

    // Player position based on the DBus
    readonly property real playerRatio: player ? clampRatio(player.position / stableLen) : 0
    // Mouse dragging position (0.0-1.0)
    property real previewRatio: -1
    // Mouse click position (0.0-1.0)
    property real committedRatio: -1
    // Currrent position the UI is displaying
    property real visualRatio: {
        if (previewRatio >= 0)
            return previewRatio;
        if (committedRatio >= 0)
            return committedRatio;
        return playerRatio;
    }

    property int settleChecks: 0
    property bool isDragging: false

    implicitHeight: barHeight + 8

    function clampRatio(ratio) {
        return Math.max(0, Math.min(1, ratio));
    }

    Timer {
        interval: 500
        running: {
            if (!root.Window.window)
                return false;
            return root.Window.window.visible && root.player && root.previewRatio < 0 && root.committedRatio < 0;
        }
        repeat: true
        onTriggered: root.player.positionChanged()
    }

    Timer {
        id: settleTimer
        interval: 80
        repeat: true

        onTriggered: {
            if (root.settleChecks <= 0 || root.previewRatio >= 0) {
                stop();
                return;
            }

            let isSettled = Math.abs(root.playerRatio - root.committedRatio) <= 0.0015;
            if (isSettled) {
                root.committedRatio = -1;
                stop();
                return;
            }
            root.settleChecks -= 1;
        }
    }

    Rectangle {
        width: parent.width
        height: root.barHeight
        anchors.verticalCenter: parent.verticalCenter
        color: root.trackColor
        radius: height / 2
    }

    Rectangle {
        width: Math.max(0, Math.min(parent.width, parent.width * root.visualRatio))
        height: root.barHeight
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: root.fillColor
        radius: height / 2

        Behavior on width {
            enabled: root.previewRatio < 0 && root.committedRatio < 0
            NumberAnimation {
                duration: 500
                easing.type: Easing.Linear
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: root.player && root.player.canSeek && root.stableLen > 0
        hoverEnabled: true

        property real pressX: 0

        onPressed: mouse => {
            if (!root.player)
                return;
            pressX = mouse.x;
            root.isDragging = false;

            settleTimer.stop();
            root.committedRatio = -1;
            root.previewRatio = root.clampRatio(mouse.x / width);
        }

        onPositionChanged: mouse => {
            if (pressed && root.player) {
                if (!root.isDragging && Math.abs(mouse.x - pressX) >= 4) {
                    root.isDragging = true;
                }
                root.previewRatio = root.clampRatio(mouse.x / width);
            }
        }

        onReleased: mouse => {
            if (!root.player) {
                root.previewRatio = -1;
                return;
            }

            const finalRatio = root.clampRatio(mouse.x / width);
            root.player.position = Math.max(0.1, finalRatio * root.stableLen);

            root.committedRatio = finalRatio;
            root.previewRatio = -1;
            root.settleChecks = 15;
            settleTimer.restart();
        }

        onCanceled: {
            root.previewRatio = -1;
            root.isDragging = false;
        }
    }
}
