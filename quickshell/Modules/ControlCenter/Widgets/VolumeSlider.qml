import QtQuick
import "../Components"
import "../../../Services"

ControlSlider {
    id: root

    icon: Audio.icon
    value: Audio.volume

    onValChanged: val => Audio.setVolume(val)
    onIconClicked: Audio.setMute()
}
