import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property ShellScreen modelData
            screen: modelData

            // color: Theme.background
            // color: Theme.surfaceWeak
            color: "transparent"

            anchors {
                top: true
                bottom: true
                left: true
            }

            // implicitWidth: 200
            implicitWidth: 45

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

                    Repeater {
                        model: Hyprland.workspaces.values.filter(w => (w.id > 0) && (w.monitor.name === screen.name))

                        Rectangle {
                            id: delegate
                            required property HyprlandWorkspace modelData
                            property alias item: delegate.modelData

                            Layout.alignment: Qt.AlignHCenter
                            Layout.fillWidth: true
                            Layout.preferredHeight: width
                            // Layout.preferredWidth: 16

                            color: Theme.background
                            radius: 8

                            Text {
                                text: parent.item.name

                                color: Theme.text
                                rotation: -90

                                anchors.centerIn: parent

                                font {
                                    pixelSize: 16
                                    bold: parent.item.active
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("workspace " + (parent.item.id))
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                // Rectangle {
                //     Layout.fillWidth: true
                //     implicitHeight: 1
                // }

                SystemTray {
                    Layout.alignment: Qt.AlignHCenter
                }

                // Rectangle {
                //     Layout.fillWidth: true
                //     implicitHeight: 1
                // }

                ClockWidget {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
