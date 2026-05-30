import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    id: root
    spacing: 5

    Repeater {
        model: SystemTray.items

        Item {
            id: trayItem
            implicitWidth: trayItemIcon.implicitWidth
            implicitHeight: trayItemIcon.implicitHeight

            Image {
                id: trayItemIcon
                source: modelData.icon || ""
                sourceSize: Qt.size(16, 16)
                fillMode: Image.PreserveAspectFit

                anchors.centerIn: parent
                mipmap: true
            }

            QsMenuAnchor {
                id: menuAnchor
                anchor.window: barWindow
                anchor.item: trayItemIcon
                menu: modelData.menu
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                cursorShape: Qt.PointingHandCursor

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate();
                    } else if (mouse.button === Qt.RightButton) {
                        if (modelData.hasMenu) {
                            menuAnchor.open();
                        } else {
                            modelData.activate();
                        }
                    } else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate();
                    }
                }
            }
        }
    }
}
