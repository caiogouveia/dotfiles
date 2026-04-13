import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

ShellRoot {
    Variants {
        model: Quickshell.screens
        
        delegate: PanelWindow {
            id: barWindow
            
            anchors.top: true
            anchors.left: true
            anchors.right: true
            
            margins.top: 5
            margins.left: 5
            margins.right: 5
            
            // Usando implicitHeight para evitar o warning
            implicitHeight: 40
            color: "transparent"
            exclusiveZone: implicitHeight + margins.top
            
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell-bar"

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.35)
                radius: 15
                border.color: Qt.rgba(1, 1, 1, 0.225)
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    // ESQUERDA: Workspaces
                    Row {
                        Layout.alignment: Qt.AlignLeft
                        spacing: 8
                        
                        Repeater {
                            // Usando o modelo de workspaces do serviço global
                            model: Hyprland.workspaces
                            delegate: Rectangle {
                                width: 28
                                height: 28
                                radius: 14
                                // modelData se refere ao objeto Workspace
                                color: modelData.active ? "#33ccff" : Qt.rgba(1, 1, 1, 0.1)
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.name
                                    color: "white"
                                    font.bold: true
                                }
                                
                                TapHandler {
                                    // Ação de focar o workspace
                                    onTapped: modelData.focus()
                                }
                            }
                        }
                    }

                    // MEIO: Música e Controles
                    Row {
                        Layout.alignment: Qt.AlignCenter
                        spacing: 15
                        visible: musicText.text !== ""

                        Row {
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter

                            MediaButton { icon: ""; cmd: "playerctl previous" }
                            
                            MediaButton { 
                                id: playPauseBtn
                                property string status: "Paused"
                                icon: status === "Playing" ? "" : ""
                                cmd: "playerctl play-pause"
                                
                                Process {
                                    id: statusProc
                                    command: ["playerctl", "status"]
                                    running: true
                                    stdout: SplitParser {
                                        onRead: data => playPauseBtn.status = data.trim()
                                    }
                                }
                                Timer {
                                    interval: 1000; running: true; repeat: true
                                    onTriggered: statusProc.running = true
                                }
                            }

                            MediaButton { icon: ""; cmd: "playerctl next" }
                        }

                        Text {
                            id: musicText
                            color: "white"
                            font.pointSize: 10
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.maximumWidth: 250
                            anchors.verticalCenter: parent.verticalCenter

                            Process {
                                id: musicProc
                                command: ["sh", "-c", "playerctl metadata --format '{{title}} - {{artist}}' 2>/dev/null"]
                                running: true
                                stdout: SplitParser {
                                    onRead: data => musicText.text = data.trim()
                                }
                            }

                            Timer {
                                interval: 2000; running: true; repeat: true
                                onTriggered: musicProc.running = true
                            }
                        }
                    }

                    // DIREITA: Status e Relógio
                    Row {
                        Layout.alignment: Qt.AlignRight
                        spacing: 18

                        StatusModule {
                            id: netMod
                            icon: ""
                            cmd: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 | head -n1 || echo 'Offline'"]
                        }

                        StatusModule {
                            id: volMod
                            icon: ""
                            cmd: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)\"%\"}'"]
                        }

                        StatusModule {
                            id: batMod
                            icon: ""
                            cmd: ["sh", "-c", "[ -d /sys/class/power_supply/BAT0 ] && cat /sys/class/power_supply/BAT0/capacity | awk '{print $1\"%\"}' || echo 'N/A'"]
                        }

                        Text {
                            id: clock
                            color: "white"
                            font.bold: true
                            font.pointSize: 10
                            text: "00:00"
                            
                            Timer {
                                interval: 1000; running: true; repeat: true
                                onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd dd/MM - hh:mm:ss")
                            }
                        }

                        Text {
                            text: "⏻"
                            color: "#ff5555"
                            font.pointSize: 14
                            
                            TapHandler {
                                onTapped: Quickshell.execDetached(["/home/caiogouveia/DEV/dotfiles/scripts/power-menu.sh"])
                            }
                        }
                    }
                }
            }

            component MediaButton : Text {
                property string icon: ""
                property string cmd: ""
                text: icon
                color: mediaHover.hovered ? "#33ccff" : "white"
                font.family: "Font Awesome 6 Free"
                font.pointSize: 12
                anchors.verticalCenter: parent.verticalCenter
                
                HoverHandler { id: mediaHover }
                TapHandler {
                    onTapped: Quickshell.execDetached([cmd])
                }
            }

            component StatusModule : Row {
                property string icon: ""
                property var cmd: []
                property string value: "..."
                spacing: 5

                Process {
                    id: proc
                    command: cmd
                    running: true
                    stdout: SplitParser {
                        onRead: data => value = data.trim()
                    }
                }

                Timer {
                    interval: 4000; running: true; repeat: true
                    onTriggered: proc.running = true
                }

                Text {
                    text: icon
                    color: "#33ccff"
                    font.family: "Font Awesome 6 Free"
                    font.pointSize: 11
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: value
                    color: "white"
                    font.pointSize: 10
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
