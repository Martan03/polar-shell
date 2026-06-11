import QtQuick
import "../../../Services"
import "../Components"

IconItem {
    icon: Weather.currentIcon
    text: Weather.currentTemp

    Component.onCompleted: Weather.register()
    Component.onDestruction: Weather.unregister()
}
