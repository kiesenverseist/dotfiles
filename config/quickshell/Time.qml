pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
	property string time: {
		Qt.formatDateTime(clock.date, "hh\nmm\nss\n\ndd\nMM\nyy")
	}

	SystemClock {
		id: clock
		precision: SystemClock.Seconds
	}
}
