pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> players: Mpris.players.values
    property MprisPlayer active: null

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
