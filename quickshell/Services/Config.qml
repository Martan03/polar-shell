pragma Singleton
import QtQuick
import QtCore

Item {
    id: root

    Settings {
        id: appSettings
        category: "Weather"

        location: Qt.resolvedUrl("../quickshell.conf")

        property real weatherLat: 50.08654
        property real weatherLon: 14.412
        property string weatherTz: "auto"
    }

    property alias weatherLat: appSettings.weatherLat
    property alias weatherLon: appSettings.weatherLon
    property alias weatherTz: appSettings.weatherTz
}
