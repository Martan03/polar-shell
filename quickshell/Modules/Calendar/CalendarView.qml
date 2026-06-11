import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../Widgets"
import "../../Services"

Item {
    id: root

    implicitHeight: content.implicitHeight

    property date currentDate: new Date()
    property date viewDate: new Date(currentDate.getFullYear(), currentDate.getMonth(), 1)
    property date selectedDate: currentDate

    property bool showShared: false

    property var eventsDb: ({})
    property var dailyEvents: {
        const key = formatKeyDate(root.selectedDate);
        const events = eventsDb[key] || [];
        return events.filter(event => root.showShared || event.isMain);
    }

    onViewDateChanged: {
        fetchMonthWindow();
    }

    Component.onCompleted: {
        fetchMonthWindow();
    }

    function fetchMonthWindow() {
        let year = viewDate.getFullYear();
        let month = viewDate.getMonth();

        let start = new Date(year, month - 1, 1);
        let end = new Date(year, month + 2, 0);
        let startStr = formatKeyDate(start);
        let endStr = formatKeyDate(end);

        fetchProcess.running = false;
        fetchProcess.command = ["python3", Qt.resolvedUrl("../../scripts/cal_events.py").toString().replace("file://", ""), startStr, endStr];
        console.log(fetchProcess.command);
        fetchProcess.running = true;
    }

    function formatKeyDate(d) {
        let year = d.getFullYear();
        let month = String(d.getMonth() + 1).padStart(2, '0');
        let day = String(d.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    function isSameDate(d1, d2) {
        return d1.getDate() === d2.getDate() && d1.getMonth() === d2.getMonth() && d1.getFullYear() === d2.getFullYear();
    }

    function hasEvents(d) {
        const key = formatKeyDate(d);
        const events = eventsDb[key] || [];
        return events.some(event => root.showShared || event.isMain);
    }

    function getDaysInView() {
        let year = viewDate.getFullYear();
        let month = viewDate.getMonth();
        let firstDay = new Date(year, month, 1);
        let lastDay = new Date(year, month + 1, 0);

        let startOffset = (firstDay.getDay() + 6) % 7;

        let days = [];
        let prevLastDay = new Date(year, month, 0).getDate();

        for (let i = startOffset - 1; i >= 0; i--) {
            days.push({
                isCurrent: false,
                date: new Date(year, month - 1, prevLastDay - i)
            });
        }

        for (let i = 1; i <= lastDay.getDate(); i++) {
            days.push({
                isCurrent: true,
                date: new Date(year, month, i)
            });
        }

        let remain = 42 - days.length;
        for (let i = 1; i <= remain; i++) {
            days.push({
                isCurrent: false,
                date: new Date(year, month + 1, i)
            });
        }
        return days;
    }

    Process {
        id: fetchProcess

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text)
                    return;

                try {
                    const incoming = JSON.parse(this.text.trim());
                    root.eventsDb = Object.assign({}, root.eventsDb, incoming);
                } catch (e) {
                    console.error("Error parsing Google Calendar payload: " + e);
                }
            }
        }
    }

    Timer {
        interval: 900000
        running: root.Window.window
        repeat: true
        onTriggered: root.fetchMonthWindow()
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: 15

        RowLayout {
            Layout.fillWidth: true

            IconButton {
                icon: ""
                onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() - 1, 1)
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: root.viewDate.toLocaleString(Qt.locale(), "MMMM yyyy")
            }

            IconButton {
                icon: ""
                onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + 1, 1)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 5

            Repeater {
                model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font.pixelSize: 12
                    color: Theme.muted
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 7
            rowSpacing: 5
            columnSpacing: 5
            uniformCellWidths: true

            Repeater {
                model: root.getDaysInView()

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: width
                    radius: 8

                    color: {
                        if (isSameDate(modelData.date, root.selectedDate))
                            return Theme.primary;
                        return "transparent";
                    }

                    border.color: isSameDate(modelData.date, root.currentDate) && !isSameDate(modelData.date, root.selectedDate) ? Theme.primary : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: modelData.date.getDate()

                        color: {
                            if (root.isSameDate(modelData.date, root.selectedDate))
                                return Theme.surface;
                            if (!modelData.isCurrent)
                                return Theme.muted;
                            return Theme.foreground;
                        }
                    }

                    Rectangle {
                        visible: root.hasEvents(modelData.date)
                        width: 4
                        height: 4
                        radius: 2
                        color: root.isSameDate(modelData.date, root.selectedDate) ? Theme.surface : Theme.primary
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            const date = modelData.date;
                            root.selectedDate = date;
                            if (date.getMonth() !== root.viewDate.getMonth() || date.getFullYear() !== root.viewDate.getFullYear()) {
                                root.viewDate = new Date(date.getFullYear(), date.getMonth(), 1);
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Theme.border
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 5

                StyledText {
                    Layout.fillWidth: true
                    text: "Events for " + root.selectedDate.toLocaleDateString(Qt.locale(), "d. MMMM")
                    color: Theme.muted
                    font.pixelSize: 12
                }

                IconButton {
                    icon: ""
                    onClicked: root.showShared = !root.showShared
                    iconColor: root.showShared ? Theme.primary : Theme.muted
                    iconSize: 16
                }
            }

            Repeater {
                model: root.dailyEvents
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    StyledText {
                        Layout.preferredWidth: 105
                        Layout.alignment: Qt.AlignTop
                        text: modelData.time
                        color: Theme.primary
                        font.bold: true
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        StyledText {
                            Layout.fillWidth: true
                            text: modelData.title
                            elide: Text.ElideRight
                        }

                        StyledText {
                            Layout.fillWidth: true
                            visible: !modelData.isMain
                            text: modelData.calendar || "Shared Event"
                            color: Theme.muted
                            font.pixelSize: 10
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            StyledText {
                visible: root.dailyEvents.length === 0
                text: "No events scheduled."
                font.italic: true
            }
        }
    }
}
