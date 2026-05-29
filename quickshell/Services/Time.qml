pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string datetime: {
        Qt.formatDateTime(clock.date, "dd.MM.yyyy hh:mm:ss");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
