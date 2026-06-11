import QtQuick
import QtQuick.Layouts
import "../../Widgets"
import "../../Services"

Item {
    id: root

    implicitHeight: content.implicitHeight

    property int currentTab: 0

    readonly property var historyModels: [SysMonitor.cpuHistory, SysMonitor.memHistory, SysMonitor.gpuHistory]
    readonly property var appsModels: [SysMonitor.cpuApps, SysMonitor.memApps, SysMonitor.gpuApps]
    readonly property var tabNames: ["CPU", "MEM", "GPU"]

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: 15

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 28

            Rectangle {
                width: parent.width / 3
                height: parent.height
                x: root.currentTab * width

                radius: 8
                color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15)
                border.color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.3)
                border.width: 1

                Behavior on x {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutQuart
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: 3
                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        StyledText {
                            text: root.tabNames[index]
                            anchors.centerIn: parent
                            font.bold: root.currentTab === index
                            font.pixelSize: 11
                            color: root.currentTab === index ? Theme.primary : Theme.muted

                            Behavior on color {
                                ColorAnimation {
                                    duration: 250
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.currentTab = index
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 115

            Canvas {
                id: graphCanvas

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15

                property var activeHistory: root.historyModels[root.currentTab]
                onActiveHistoryChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var history = activeHistory || [];
                    if (history.length === 0)
                        return;

                    var maxPoints = SysMonitor.maxHistoryLen;
                    var stepX = width / (maxPoints - 1);

                    ctx.beginPath();
                    ctx.setLineDash([4, 4]);
                    ctx.strokeStyle = Qt.rgba(Theme.muted.r, Theme.muted.g, Theme.muted.b, 0.2);
                    ctx.lineWidth = 1;
                    ctx.moveTo(0, height * 0.25);
                    ctx.lineTo(width, height * 0.25);
                    ctx.moveTo(0, height * 0.5);
                    ctx.lineTo(width, height * 0.5);
                    ctx.moveTo(0, height * 0.75);
                    ctx.lineTo(width, height * 0.75);
                    ctx.stroke();
                    ctx.setLineDash([]);

                    var points = [];
                    for (var i = 0; i < history.length; i++) {
                        var x = i * stepX;
                        var y = height - (history[i] / 100.0) * height;
                        points.push({
                            x: x,
                            y: y
                        });
                    }

                    ctx.beginPath();
                    ctx.moveTo(points[0].x, height);
                    for (var j = 0; j < points.length; j++) {
                        ctx.lineTo(points[j].x, points[j].y);
                    }
                    ctx.lineTo(points[points.length - 1].x, height);
                    ctx.closePath();

                    var grad = ctx.createLinearGradient(0, 0, 0, height);
                    grad.addColorStop(0.0, Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.2));
                    grad.addColorStop(1.0, "transparent");
                    ctx.fillStyle = grad;
                    ctx.fill();

                    ctx.beginPath();
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = Theme.primary;
                    ctx.lineJoin = "round";
                    ctx.moveTo(points[0].x, points[0].y);
                    for (var k = 1; k < points.length; k++) {
                        ctx.lineTo(points[k].x, points[k].y);
                    }
                    ctx.stroke();
                }
            }

            StyledText {
                text: "100%"
                anchors.top: parent.top
                anchors.left: parent.left
                font.pixelSize: 8
                color: Theme.muted
            }
            StyledText {
                text: "0%"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                font.pixelSize: 8
                color: Theme.muted
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            StyledText {
                text: "Top Applications"
                font.pixelSize: 11
                font.bold: true
                color: Theme.primary
                Layout.bottomMargin: 2
            }

            Repeater {
                model: root.appsModels[root.currentTab]
                delegate: RowLayout {
                    Layout.fillWidth: true

                    StyledText {
                        text: modelData.name
                        font.pixelSize: 12
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    StyledText {
                        text: modelData.usage
                        font.pixelSize: 12
                        font.bold: true
                        color: Theme.muted
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                visible: root.appsModels[root.currentTab].length === 0

                StyledText {
                    text: "No active resource data"
                    anchors.centerIn: parent
                    font.pixelSize: 11
                    color: Theme.muted
                }
            }
        }
    }
}
