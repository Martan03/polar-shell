import QtQuick

Item {
    id: root

    property bool timerEnabled: true
    property int listeners: 0
    property int pollInterval: 3000

    signal pollAction

    function register() {
        root.listeners++;
        if (root.listeners === 1) {
            root.pollAction();
        }
    }

    function unregister() {
        if (root.listeners > 0) {
            root.listeners--;
        }
    }

    Timer {
        id: internalTimer
        interval: root.pollInterval
        repeat: true
        running: root.timerEnabled && root.listeners > 0
        onTriggered: root.pollAction()
    }
}
