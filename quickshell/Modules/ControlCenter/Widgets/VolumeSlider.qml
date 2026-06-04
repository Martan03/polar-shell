import QtQuick
import "../Components"
import "../../../Services"

ControlSlider {
    id: root

    property string type: "sink"

    icon: type === "sink" ? Audio.icon : Audio.micIcon
    value: type === "sink" ? Audio.volume : Audio.micVolume

    onValChanged: val => {
        if (type === "sink") {
            Audio.setVolume(val);
        } else {
            Audio.setMicVolume(val);
        }
    }
    onIconClicked: {
        if (type === "sink") {
            Audio.setMute();
        } else {
            Audio.setMicMute();
        }
    }
}
