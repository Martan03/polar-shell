pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> players: Mpris.players.values
    property MprisPlayer active: null
    property real activeStableLen: 0

    onActiveChanged: {
        activeStableLen = getStableLen(active);
    }

    onPlayersChanged: _resolveActive()
    Component.onCompleted: _resolveActive()

    Instantiator {
        model: root.players
        delegate: Connections {
            required property MprisPlayer modelData
            target: modelData

            function onPlaybackStateChanged() {
                root._resolveActive();
            }
        }
    }

    Timer {
        interval: 1000
        running: root.active?.playbackState === MprisPlaybackState.Playing
        repeat: true
        onTriggered: root.active?.positionChanged()
    }

    Connections {
        target: root.active

        function onTrackTitleChanged() {
            root.activeStableLen = root.getStableLen(root.active);
            if (root.isIdle(root.active))
                root._resolveActive();
        }

        function onTrackArtistChanged() {
            if (root.isIdle(root.active))
                root._resolveActive();
        }

        function onLengthChanged() {
            if (root.active && root.active.lengthSupported && root.active.length > 1)
                root.activeStableLen = root.active.length;
        }

        function onPlaybackStateChanged() {
            if (root.isIdle(root.active))
                root._resolveActive();
        }
    }

    function _resolveActive() {
        let playing = players.find(p => p.isPlaying && !isFirefoxHover(p));
        if (playing) {
            active = playing;
            return;
        }

        if (active && players.indexOf(active) >= 0) {
            return;
        }

        active = players.find(p => !isFirefoxHover(p)) ?? null;
    }

    function getStableLen(player) {
        return (player && player.lengthSupported && player.length > 1) ? player.length : 0;
    }

    function isIdle(player) {
        return player && player.isPlaying && !player.trackTitle && !player.trackArtist;
    }

    function isFirefoxHover(player) {
        if (!player)
            return false;
        const id = (player.identity || "").toLowerCase();
        if (!id.includes("firefox"))
            return false;

        const url = (player.metadata?.["xesam:url"] || "").toString();
        return /^https?:\/\/(www\.)?youtube\.com\/?($|\?|#)/i.test(url);
    }

    readonly property bool hasMedia: active !== null
    readonly property bool isPlaying: active?.isPlaying ?? false

    readonly property string title: active?.trackTitle ?? ""
    readonly property string artist: active?.trackArtist ?? ""

    readonly property string artUrl: active?.trackArtUrl ?? ""

    readonly property real length: active?.length ?? 0
    readonly property real pos: active?.position ?? 0

    readonly property real volume: active?.volume ?? 0

    readonly property string displayString: {
        if (!hasMedia)
            return "";
        if (artist && title)
            return `${artist} - ${title}`;
        if (title)
            return title;
        return "Unknown Media";
    }

    readonly property string icon: isPlaying ? "" : ""
}
