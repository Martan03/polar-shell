pragma Singleton
import QtQuick

QtObject {
    readonly property string font: "CaskaydiaCove NF"
    readonly property int fontSize: 13

    readonly property color primary: GecolColors.primary
    readonly property color primaryHover: GecolColors.primaryHover
    readonly property color secondary: GecolColors.secondary

    readonly property color background: GecolColors.background
    readonly property color surface: GecolColors.surface
    readonly property color border: GecolColors.border

    readonly property color foreground: GecolColors.foreground
    readonly property color muted: GecolColors.muted

    readonly property color success: GecolColors.success
    readonly property color warning: GecolColors.warning
    readonly property color error: GecolColors.error
}
