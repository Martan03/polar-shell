import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import "../Services"
import "../Widgets"

PopupWindow {
    id: root

    anchor.edges: Qt.LeftEdge
    anchor.rect.y: 30
    color: "transparent"

    implicitWidth: 350
    implicitHeight: 130

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        onCleared: {
            root.visible = false;
        }
    }

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(() => {
                focusGrab.active = true;
            });
        } else {
            focusGrab.active = false;
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: root.visible = false
    }

    Rectangle {
        id: surface

        anchors.fill: parent
        color: Theme.surface
        radius: 16

        border.color: Theme.primary
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            ClippingRectangle {
                implicitWidth: 100
                implicitHeight: 100
                radius: 10
                color: Theme.border

                Image {
                    anchors.fill: parent
                    source: Mpris.artUrl
                    fillMode: Image.PreserveAspectCrop
                    mipmap: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5

                StyledText {
                    text: Mpris.active?.identity ?? ""
                    color: Theme.primary
                    font.pixelSize: 11
                    font.bold: true
                    font.capitalization: Font.SmallCaps
                    Layout.fillWidth: true
                }

                ColumnLayout {
                    spacing: 2

                    StyledText {
                        text: Mpris.title
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    StyledText {
                        text: Mpris.artist
                        color: Theme.muted
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    id: progress
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    implicitHeight: 4
                    radius: 2
                    color: Theme.border

                    property real visualVal: (Mpris.active && Mpris.length > 0) ? (Mpris.pos / Mpris.length) : 0

                    Timer {
                        interval: 500
                        running: Mpris.isPlaying && !seekArea.pressed
                        repeat: true
                        onTriggered: Mpris.active?.positionChanged()
                    }

                    Rectangle {
                        id: activeFill
                        width: parent.width * progress.visualVal
                        height: parent.height
                        radius: 2
                        color: Theme.primary

                        // Behavior on width {
                        //     enabled: !seekArea.pressed
                        //     NumberAnimation {
                        //         duration: 500
                        //         easing.type: Easing.Linear
                        //     }
                        // }
                    }

                    MouseArea {
                        id: seekArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onPressed: mouse => {
                            progress.visualVal = Math.max(0, Math.min(1, mouse.x / width));
                        }

                        onPositionChanged: mouse => {
                            if (pressed) {
                                progress.visualVal = Math.max(0, Math.min(1, mouse.x / width));
                            }
                        }

                        onReleased: mouse => {
                            if (!Mpris.active || Mpris.length <= 0)
                                return;

                            let finalPercent = Math.max(0, Math.min(1, mouse.x / width));
                            let newPos = finalPercent * Mpris.length;

                            Mpris.active.position = newPos;
                            Mpris.active.positionChanged();
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    spacing: 3

                    IconButton {
                        icon: "󰒮"
                        onClicked: Mpris.active?.previous()
                        iconOffsetX: -1
                    }

                    IconButton {
                        icon: Mpris.icon
                        iconSize: 13
                        onClicked: Mpris.active?.togglePlaying()
                        bg: Theme.primary
                        hoverBg: Theme.primaryHover
                        iconColor: Theme.border
                    }

                    IconButton {
                        icon: "󰒭"
                        onClicked: Mpris.active?.next()
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.alignment: Qt.AlignRight
                        implicitWidth: volRow.implicitWidth
                        implicitHeight: volRow.implicitHeight

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.NoButton

                            onWheel: wheel => {
                                if (!Mpris.active)
                                    return;

                                let step = 0.05;
                                if (wheel.angleDelta.y > 0) {
                                    Mpris.active.volume = Math.min(1.0, Mpris.volume + step);
                                } else if (wheel.angleDelta.y < 0) {
                                    Mpris.active.volume = Math.max(0.0, Mpris.volume - step);
                                }
                            }
                        }

                        RowLayout {
                            id: volRow
                            spacing: 0

                            IconButton {
                                icon: {
                                    if (Mpris.volume == 0.0)
                                        return "󰝟";
                                    if (Mpris.volume > 0.6)
                                        return "";
                                    if (Mpris.volume > 0.3)
                                        return "";
                                    return "";
                                }
                                iconSize: 14

                                property real savedVolume: 1.0

                                onClicked: {
                                    if (!Mpris.active)
                                        return;

                                    if (Mpris.volume > 0) {
                                        savedVolume = Mpris.volume;
                                        Mpris.active.volume = 0;
                                    } else {
                                        Mpris.active.volume = savedVolume;
                                    }
                                }
                            }

                            StyledText {
                                text: Math.round(Mpris.volume * 100) + "%"
                                color: Theme.muted
                                font.pixelSize: 11

                                Layout.preferredWidth: 25
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                }
            }
        }
    }
}
