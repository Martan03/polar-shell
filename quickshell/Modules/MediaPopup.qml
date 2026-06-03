import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../Services"
import "../Widgets"

Popup {
    id: root

    implicitWidth: 350
    implicitHeight: content.implicitHeight + 30

    RowLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15

        spacing: 15

        ClippingRectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: height

            radius: 10
            color: Theme.border

            Image {
                anchors.fill: parent
                source: MprisCtl.artUrl
                fillMode: Image.PreserveAspectCrop
                mipmap: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            StyledText {
                text: MprisCtl.active?.identity ?? ""
                color: Theme.primary
                font.pixelSize: 11
                font.bold: true
                font.capitalization: Font.SmallCaps
                Layout.fillWidth: true
            }

            ColumnLayout {
                spacing: 2

                StyledText {
                    text: MprisCtl.title
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                StyledText {
                    text: MprisCtl.artist
                    color: Theme.muted
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            ProgressBar {
                Layout.fillWidth: true
                Layout.topMargin: 5
                player: MprisCtl.active
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 5
                spacing: 3

                IconButton {
                    icon: "󰒮"
                    onClicked: MprisCtl.active?.previous()
                    iconOffsetX: -1
                }

                IconButton {
                    icon: MprisCtl.icon
                    iconSize: 13
                    onClicked: MprisCtl.active?.togglePlaying()
                    bg: Theme.primary
                    hoverBg: Theme.primaryHover
                    iconColor: Theme.border
                }

                IconButton {
                    icon: "󰒭"
                    onClicked: MprisCtl.active?.next()
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
                            if (!MprisCtl.active)
                                return;

                            let step = 0.05;
                            if (wheel.angleDelta.y > 0) {
                                MprisCtl.active.volume = Math.min(1.0, MprisCtl.volume + step);
                            } else if (wheel.angleDelta.y < 0) {
                                MprisCtl.active.volume = Math.max(0.0, MprisCtl.volume - step);
                            }
                        }
                    }

                    RowLayout {
                        id: volRow
                        spacing: 0

                        IconButton {
                            icon: {
                                if (MprisCtl.volume == 0.0)
                                    return "󰝟";
                                if (MprisCtl.volume > 0.6)
                                    return "";
                                if (MprisCtl.volume > 0.3)
                                    return "";
                                return "";
                            }
                            iconSize: 14

                            property real savedVolume: 1.0

                            onClicked: {
                                if (!MprisCtl.active)
                                    return;

                                if (MprisCtl.volume > 0) {
                                    savedVolume = MprisCtl.volume;
                                    MprisCtl.active.volume = 0;
                                } else {
                                    MprisCtl.active.volume = savedVolume;
                                }
                            }
                        }

                        StyledText {
                            text: Math.round(MprisCtl.volume * 100) + "%"
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
