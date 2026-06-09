import QtQuick
import QtQuick.Layouts
import "../../../Widgets"
import "../../../Services"

Item {
    id: root

    implicitHeight: content.implicitHeight

    property string currentTemp: "--"
    property string currentIcon: "󰖐"
    property string currentDesc: "Loading..."
    property var hourlyForecast: []

    Component.onCompleted: fetchWeather()

    function fetchWeather() {
        var xhr = new XMLHttpRequest();
        var url = `https://api.open-meteo.com/v1/forecast?latitude=${Config.weatherLat}&longitude=${Config.weatherLon}&current=temperature_2m,weather_code&hourly=temperature_2m,precipitation_probability,weather_code&timezone=${Config.weatherTz}&forecast_days=2`;

        xhr.open("GET", url);
        xhr.onreadystatechange = () => {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;

            if (xhr.status !== 200) {
                console.error("Failed to fetch weather:", xhr.status);
                return;
            }

            try {
                parseWeatherData(JSON.parse(xhr.responseText));
            } catch (e) {
                console.error("Weather parsing error:", e);
            }
        };
        xhr.send();
    }

    function parseWeatherData(data) {
        root.currentTemp = Math.round(data.current.temperature_2m) + "°C";
        let curWmo = mapWmoCode(data.current.weather_code);
        root.currentIcon = curWmo.icon;
        root.currentDesc = curWmo.desc;

        let forecast = [];
        let now = new Date();

        let startId = 0;
        for (let i = 0; i < data.hourly.time.length; i++) {
            let hourDate = new Date(data.hourly.time[i]);
            if (hourDate >= now) {
                startId = i;
                break;
            }
        }

        for (let i = 0; i < 12; i++) {
            let id = startId + i;
            if (id >= data.hourly.time.length)
                continue;

            const timeObj = new Date(data.hourly.time[id]);
            const timeStr = String(timeObj.getHours()).padStart(2, '0') + ":00";

            const wmo = mapWmoCode(data.hourly.weather_code[id]);
            const precip = data.hourly.precipitation_probability[id];

            forecast.push({
                time: i === 0 ? "Now" : timeStr,
                temp: Math.round(data.hourly.temperature_2m[id]) + "°",
                precip: precip > 0 ? precip + "%" : "",
                icon: wmo.icon
            });
        }

        root.hourlyForecast = forecast;
    }

    function mapWmoCode(code) {
        if (code === 0)
            return {
                icon: "󰖙",
                desc: "Clear sky"
            };
        if (code === 1)
            return {
                icon: "󰖕",
                desc: "Mostly clear"
            };
        if (code === 2)
            return {
                icon: "󰖐",
                desc: "Partly cloudy"
            };
        if (code === 3)
            return {
                icon: "󰖐",
                desc: "Overcast"
            };
        if (code === 45 || code === 48)
            return {
                icon: "󰖑",
                desc: "Fog"
            };
        if (code >= 51 && code <= 55)
            return {
                icon: "󰖗",
                desc: "Drizzle"
            };
        if (code >= 61 && code <= 65)
            return {
                icon: "󰖖",
                desc: "Rain"
            };
        if (code >= 71 && code <= 77)
            return {
                icon: "󰖘",
                desc: "Snow"
            };
        if (code >= 80 && code <= 82)
            return {
                icon: "󰖖",
                desc: "Showers"
            };
        if (code >= 95 && code <= 99)
            return {
                icon: "󰖓",
                desc: "Thunderstorm"
            };
        return {
            icon: "󰖐",
            desc: "Unknown"
        };
    }

    Timer {
        interval: 180000
        running: root.Window.window
        repeat: true
        onTriggered: {
            console.log("test of weather pulling");
            root.fetchWeather();
        }
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            NerdIcon {
                icon: root.currentIcon
                Layout.alignment: Qt.AlignVCenter
                size: 40
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                StyledText {
                    text: root.currentTemp
                    font.pixelSize: 20
                    font.bold: true
                }

                StyledText {
                    text: root.currentDesc
                    color: Theme.muted
                    font.pixelSize: 12
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: 85
            orientation: ListView.Horizontal
            spacing: 15
            clip: true

            interactive: true
            boundsBehavior: Flickable.StopAtBounds

            model: root.hourlyForecast

            delegate: ColumnLayout {
                width: 45
                spacing: 6

                StyledText {
                    text: modelData.time
                    Layout.alignment: Qt.AlignHCenter
                    color: index === 0 ? Theme.primary : Theme.muted
                    font.pixelSize: 11
                }

                NerdIcon {
                    icon: modelData.icon
                    Layout.alignment: Qt.AlignHCenter
                    size: 18
                }

                StyledText {
                    text: modelData.temp
                    Layout.alignment: Qt.AlignHCenter
                    Layout.leftMargin: 4
                    font.bold: true
                }

                StyledText {
                    text: modelData.precip
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: 10
                    color: modelData.precip !== "" ? "#89b4fa" : "transparent"
                }
            }
        }
    }
}
