pragma Singleton
import QtQuick

SmartPoller {
    id: root

    property string currentTemp: "--"
    property string currentIcon: "󰖐"
    property string currentDesc: "Loading..."
    property string currentFeelsLike: "--"
    property string currentWind: "--"

    property var hourlyForecast: []
    property bool isFetching: false

    property int retryCount: 0
    property int maxRetries: 3

    pollInterval: 1800000
    onPollAction: {
        retryCount = 0;
        fetchWeather();
    }

    function fetchWeather() {
        if (root.isFetching)
            return;
        root.isFetching = true;

        var xhr = new XMLHttpRequest();
        var url = `https://api.open-meteo.com/v1/forecast?latitude=${Config.weatherLat}&longitude=${Config.weatherLon}&current=temperature_2m,apparent_temperature,wind_speed_10m,weather_code&hourly=temperature_2m,precipitation_probability,precipitation,weather_code&timezone=${Config.weatherTz}&forecast_days=2`;

        xhr.open("GET", url);
        xhr.onreadystatechange = () => {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;

            root.isFetching = false;
            if (xhr.status !== 200) {
                if (root.retryCount < root.maxRetries) {
                    root.retryCount++;
                    console.warn(`Weather fetch failed (Status: ${xhr.status}). Retrying...`);
                    retryTimer.start();
                } else {
                    console.error("Max weather retries reached.");
                    root.currentDesc = "Offline";
                }
                return;
            }

            root.retryCount = 0;
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
        root.currentFeelsLike = Math.round(data.current.apparent_temperature) + "°C";
        root.currentWind = Math.round(data.current.wind_speed_10m) + " km/h";

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

        for (let id = startId; id < data.hourly.time.length; id++) {
            const timeObj = new Date(data.hourly.time[id]);
            const timeStr = String(timeObj.getHours()).padStart(2, '0') + ":00";

            const wmo = mapWmoCode(data.hourly.weather_code[id]);
            const precip = data.hourly.precipitation_probability[id];

            forecast.push({
                time: id === startId ? "Now" : timeStr,
                temp: data.hourly.temperature_2m[id],
                precip: precip > 0 ? precip + "%" : "",
                precipMm: data.hourly.precipitation[id],
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
