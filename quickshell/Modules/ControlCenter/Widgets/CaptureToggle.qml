import QtQuick
import "../Components"
import "../../../Services"

IconToggleButton {
    icon: Capture.isRecording ? "" : "󰻃"
    active: Capture.isRecording

    enabled: !Capture.isBusy
    opacity: Capture.isBusy ? 0.5 : 1.0

    tooltipText: {
        if (Capture.captureState === Capture.stateStarting)
            return "Starting";
        if (Capture.captureState === Capture.stateRecording)
            return "Recording";
        if (Capture.captureState === Capture.stateStopping)
            return "Saving clip";
        return "Capture Screen";
    }
    onClicked: Capture.toggle()
}
