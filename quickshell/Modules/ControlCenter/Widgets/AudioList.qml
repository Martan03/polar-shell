import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../../../Widgets"
import "../../../Services"

ColumnLayout {
    id: root

    property string type: "sink"

    spacing: 4

    Repeater {
        model: Pipewire.nodes

        delegate: Rectangle {
            id: delegateRoot

            property bool isSink: !modelData.isStream && modelData.isSink && modelData.audio
            property bool isSource: !modelData.isStream && !modelData.isSink && modelData.audio

            property bool isTarget: root.type === "sink" ? isSink : isSource
            property bool isCurrent: root.type === "sink" ? Audio.sink === modelData : Audio.source === modelData

            visible: isTarget
            Layout.preferredHeight: isTarget ? 40 : 0
            Layout.fillWidth: true

            radius: 8
            color: isCurrent ? Theme.primary : (mouseArea.containsMouse ? Theme.surface : "transparent")

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                visible: delegateRoot.isTarget

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 20

                    NerdIcon {
                        anchors.centerIn: parent
                        icon: delegateRoot.isCurrent ? "󰄬" : (root.type === "sink" ? "" : "󰍬")
                        color: delegateRoot.isCurrent ? Theme.surface : Theme.muted
                    }
                }

                StyledText {
                    text: modelData.description !== "" ? modelData.description : modelData.name
                    color: delegateRoot.isCurrent ? Theme.surface : Theme.foreground
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (root.type === "sink") {
                        Pipewire.preferredDefaultAudioSink = modelData;
                    } else {
                        Pipewire.preferredDefaultAudioSource = modelData;
                    }
                }
            }
        }
    }
}
