import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

WrapperRectangle {
	margin: 2
	Layout.fillWidth: true
	radius: 8
	color: Theme.background

    ColumnLayout {
        spacing: 8

        Repeater {
            model: {
                values: SystemTray.items.values;
            }

            WrapperMouseArea {
                id: delegate
				child: icon
                required property SystemTrayItem modelData
                property alias item: delegate.modelData

                Layout.fillWidth: true
                implicitHeight: icon.implicitWidth + 5

                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true

                onClicked: event => {
                    if (event.button == Qt.LeftButton) {
                        item.activate();
                    } else if (event.button == Qt.MiddleButton) {
                        item.secondaryActivate();
                    } else if (event.button == Qt.RightButton) {
                        menuAnchor.open();
                    }
                }

                onWheel: event => {
                    event.accepted = true;
                    const points = event.angleDelta.y / 120;
                    item.scroll(points, false);
                }

                IconImage {
                    id: icon
                    anchors.centerIn: parent
                    source: parent.item.icon
                    implicitSize: 20
                }

                QsMenuAnchor {
                    id: menuAnchor
                    menu: parent.item.menu

                    anchor.window: delegate.QsWindow.window
                    anchor.adjustment: PopupAdjustment.Flip

                    anchor.onAnchoring: {
                        const window = delegate.QsWindow.window;
                        const widgetRect = window.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height);

                        menuAnchor.anchor.rect = widgetRect;
                    }
                }

                // Tooltip {
                //   relativeItem: delegate.containsMouse ? delegate : null
                //
                //   Label {
                //     text: delegate.item.tooltipTitle || delegate.item.id
                //   }
                // }
            }
        }
    }
}
