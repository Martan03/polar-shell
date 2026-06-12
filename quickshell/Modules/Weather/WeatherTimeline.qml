import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../Widgets"
import "../../Services"

Item {
    id: root

    property string maxTempLabel: ""
    property string minTempLabel: ""
    property string maxPrecipLabel: ""

    Item {
        id: axisOverlay

        width: childrenRect.width
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        StyledText {
            text: root.maxTempLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 43
            font.pixelSize: 10
            font.bold: true
            color: Theme.primary
        }

        StyledText {
            text: root.maxPrecipLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 57
            font.pixelSize: 9
            color: "#89b4fa"
        }

        StyledText {
            text: root.minTempLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 103
            font.pixelSize: 10
            font.bold: true
            color: Theme.primary
        }
    }

    ListView {
        id: hourlyList

        anchors.leftMargin: 5
        anchors.left: axisOverlay.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        orientation: ListView.Horizontal
        spacing: 5
        clip: true

        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        model: Weather.hourlyForecast

        Canvas {
            id: graphCanvas
            parent: hourlyList.contentItem
            z: -1

            width: hourlyList.contentWidth
            height: hourlyList.height

            property var chartData: Weather.hourlyForecast

            onChartDataChanged: requestPaint()
            onWidthChanged: requestPaint()
            onVisibleChanged: if (visible) {
                requestPaint();
            }

            onPaint: {
                let ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                if (!chartData || chartData.length === 0)
                    return;

                let minT = chartData[0].temp;
                let maxT = chartData[0].temp;
                let maxP = 0.1;

                for (let i = 0; i < chartData.length; i++) {
                    if (chartData[i].temp < minT)
                        minT = chartData[i].temp;
                    if (chartData[i].temp > maxT)
                        maxT = chartData[i].temp;
                    if (chartData[i].precipMm > maxP)
                        maxP = chartData[i].precipMm;
                }

                let tempRange = maxT - minT || 1;
                minT -= tempRange * 0.1;
                maxT += tempRange * 0.1;
                tempRange = maxT - minT;

                root.maxTempLabel = Math.round(maxT) + "°";
                root.minTempLabel = Math.round(minT) + "°";
                root.maxPrecipLabel = maxP > 0.05 ? maxP.toFixed(1) + " mm" : "";

                var itemW = 58;
                var spacing = 5;
                var graphTop = 50;
                var graphBottom = 110;
                var graphHeight = graphBottom - graphTop;

                ctx.beginPath();
                ctx.setLineDash([4, 4]);
                ctx.strokeStyle = Qt.rgba(Theme.muted.r, Theme.muted.g, Theme.muted.b, 0.3);
                ctx.lineWidth = 1;
                ctx.moveTo(0, graphTop);
                ctx.lineTo(width, graphTop);
                ctx.moveTo(0, graphBottom);
                ctx.lineTo(width, graphBottom);
                ctx.stroke();
                ctx.setLineDash([]);

                ctx.fillStyle = "rgba(137, 180, 250, 0.6)";
                for (let j = 0; j < chartData.length; j++) {
                    if (chartData[j].precipMm <= 0)
                        continue;

                    let centerX = (j * (itemW + spacing)) + (itemW / 2);
                    let barH = (chartData[j].precipMm / maxP) * (graphHeight * 0.8);
                    let barW = 20;
                    ctx.fillRect(centerX - (barW / 2), graphBottom - barH, barW, barH);
                }

                ctx.beginPath();
                let lineCoords = [];
                for (let k = 0; k < chartData.length; k++) {
                    let cx = (k * (itemW + spacing)) + (itemW / 2);
                    let cy = graphBottom - ((chartData[k].temp - minT) / tempRange) * graphHeight;
                    lineCoords.push({
                        x: cx,
                        y: cy
                    });

                    if (k === 0)
                        ctx.moveTo(cx, cy);
                    else
                        ctx.lineTo(cx, cy);
                }

                ctx.lineTo(lineCoords[lineCoords.length - 1].x, graphBottom);
                ctx.lineTo(lineCoords[0].x, graphBottom);
                ctx.closePath();

                let gradient = ctx.createLinearGradient(0, graphTop, 0, graphBottom);
                gradient.addColorStop(0.0, Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.25));
                gradient.addColorStop(1.0, "transparent");
                ctx.fillStyle = gradient;
                ctx.fill();

                ctx.beginPath();
                ctx.lineWidth = 3;
                ctx.strokeStyle = Theme.primary;
                ctx.lineJoin = "round";
                for (var l = 0; l < lineCoords.length; l++) {
                    if (l === 0)
                        ctx.moveTo(lineCoords[l].x, lineCoords[l].y);
                    else
                        ctx.lineTo(lineCoords[l].x, lineCoords[l].y);
                }
                ctx.stroke();
            }
        }

        delegate: Item {
            width: 58
            height: 150

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: false
                propagateComposedEvents: true

                ToolTip.visible: containsMouse && ToolTip.text !== ""
                ToolTip.delay: 200
                ToolTip.text: modelData.precipMm > 0 ? `Rain: ${modelData.precipMm.toFixed(1)}mm` : ""
            }

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: index === 0 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : "transparent"
                border.color: index === 0 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.3) : "transparent"
                border.width: 1
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 0

                StyledText {
                    text: modelData.time
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    color: index === 0 ? Theme.primary : Theme.muted
                    font.pixelSize: 11
                    font.bold: index === 0
                }

                NerdIcon {
                    icon: modelData.icon
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    Layout.topMargin: 4
                    size: 18
                    color: index === 0 ? Theme.primary : Theme.foreground
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                StyledText {
                    text: `${Math.round(modelData.temp)}°`
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                    font.bold: true
                    font.pixelSize: 13
                }

                StyledText {
                    text: modelData.precip
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                    font.pixelSize: 10
                    color: modelData.precip !== "" ? "#89b4fa" : "transparent"
                }
            }
        }
    }
}
