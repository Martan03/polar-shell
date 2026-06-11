pragma Singleton
import QtQuick

SmartPoller {
    id: root

    property string currentTemp: "--"
    property string currentIcon: "󰖐"
    property string currentDesc: "Loading..."
    property var hourlyForecast: []
    property bool isFetching: false

    property var activeXhr: null

    pollInterval: 1800000
    onPollAction: fetchWeather()

    function fetchWeather() {
        if (root.isFetching)
            return;
        root.isFetching = true;

        root.activeXhr = new XMLHttpRequest();
        var url = `https://api.open-meteo.com/v1/forecast?latitude=${Config.weatherLat}&longitude=${Config.weatherLon}&current=temperature_2m,weather_code&hourly=temperature_2m,precipitation_probability,weather_code&timezone=${Config.weatherTz}&forecast_days=2`;

        root.activeXhr.open("GET", url);
        root.activeXhr.onreadystatechange = () => {
            if (!root.activeXhr || root.activeXhr.readyState !== XMLHttpRequest.DONE)
                return;

            root.isFetching = false;
            if (root.activeXhr.status === 0) {
                console.warn("Weather fetch failed (Code 0), retrying later.");
                root.activeXhr = null;
                retryTimer.start();
                return;
            }

            if (root.activeXhr.status !== 200) {
                console.error("Failed to fetch weather:", root.activeXhr.status);
                root.activeXhr = null;
                return;
            }

            try {
                parseWeatherData(JSON.parse(root.activeXhr.responseText));
            } catch (e) {
                console.error("Weather parsing error:", e);
            }
            root.activeXhr = null;
        };
        root.activeXhr.send();
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
        id: retryTimer
        interval: 5000
        repeat: false
        onTriggered: {
            if (root.listeners > 0) {
                root.fetchWeather();
            }
        }
    }
}
