import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../Services"

PopupWindow {
    id: root

    property var anchorEdges: Qt.LeftEdge | Qt.BottomEdge
    property real yOffset: 30

    default property alias content: surface.data

    anchor.edges: anchorEdges
    anchor.rect.y: yOffset
    color: "transparent"

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(() => focusGrab.active = true);
        } else {
            focusGrab.active = false;
        }
    }

    function closePopup() {
        root.visible = false;
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        onCleared: root.closePopup()
    }

    Shortcut {
        sequence: "Escape"
        onActivated: root.closePopup()
    }

    Rectangle {
        id: surface

        anchors.fill: parent
        color: Theme.surface
        radius: 16

        border.color: Theme.primary
        border.width: 1
    }
}
