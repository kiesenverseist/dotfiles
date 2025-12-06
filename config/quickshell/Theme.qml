pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // Base16 Gruvbox Dark Hard
    readonly property color base00: "#1d2021"
    readonly property color base01: "#3c3836"
    readonly property color base02: "#504945"
    readonly property color base03: "#665c54"
    readonly property color base04: "#bdae93"
    readonly property color base05: "#d5c4a1"
    readonly property color base06: "#ebdbb2"
    readonly property color base07: "#fbf1c7"
    readonly property color base08: "#fb4934" // red
    readonly property color base09: "#fe8019" // orange
    readonly property color base0A: "#fabd2f" // yellow
    readonly property color base0B: "#b8bb26" // green
    readonly property color base0C: "#8ec07c" // aqua
    readonly property color base0D: "#83a598" // blue
    readonly property color base0E: "#d3869b" // purple
    readonly property color base0F: "#d65d0e" // dark orange

    // Helpful semantic aliases
    readonly property color background: base00
    readonly property color surface:    base01
    readonly property color surfaceAlt: base02
    readonly property color surfaceWeak: base03

    readonly property color text:       base05
    readonly property color textStrong: base06
    readonly property color textWeak:   base04

    readonly property color accent:     base0D
    readonly property color success:    base0B
    readonly property color warning:    base0A
    readonly property color error:      base08
}
