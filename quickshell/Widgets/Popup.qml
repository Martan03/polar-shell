import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../Services"

PopupWindow {
    id: root

    property var anchorEdges: Qt.BottomEdge

    property real popupGap: 5
    property bool isOpened: false

    default property alias content: surface.data

    anchor.edges: anchorEdges
    color: "transparent"

    onIsOpenedChanged: {
        if (isOpened) {
            Qt.callLater(() => focusGrab.active = true);
        } else {
            focusGrab.active = false;
        }
    }

    function toggle() {
        if (root.isOpened) {
            closePopup();
        } else {
            openPopup();
        }
    }

    function openPopup() {
        root.visible = true;
        root.isOpened = true;
    }

    function closePopup() {
        root.isOpened = false;
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        onCleared: if (root.isOpened) {
            root.closePopup();
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: root.closePopup()
    }

    Item {
        anchors.fill: parent

        Rectangle {
            id: surface

            width: parent.width
            height: parent.height - root.popupGap

            color: Qt.rgba(Theme.surface.r, Theme.surface.g, Theme.surface.b, 0.6)
            radius: 16

            border.color: Theme.primary
            border.width: 1

            transformOrigin: {
                if (root.anchorEdges & Qt.RightEdge)
                    return Item.TopRight;
                if (root.anchorEdges & Qt.LeftEdge)
                    return Item.TopLeft;
                return Item.Top;
            }

            scale: {
                if (root.isOpened)
                    return 1.0;
                if (root.anchor.item && width !== 0)
                    return root.anchor.item.width / width;
                return 0.3;
            }
            Behavior on scale {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.2
                }
            }

            y: root.isOpened ? root.popupGap : 0
            Behavior on y {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutQuart
                }
            }

            opacity: root.isOpened ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 120
                }
            }

            onOpacityChanged: {
                if (opacity === 0.0 && !root.isOpened) {
                    root.visible = false;
                }
            }
        }
    }
}
