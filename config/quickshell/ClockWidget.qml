import Quickshell.Widgets
import QtQuick

WrapperRectangle {
	margin: 2
	radius: 8
	color: Theme.background
    Text {
        color: Theme.text
        // rotation: -90
        text: Time.time
        // anchros.fill: parent
        font.pixelSize: 16
    }
}
