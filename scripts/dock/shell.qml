import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    Variants {
        model: Quickshell.screens
        
        delegate: PanelWindow {
            id: dockWindow
            property var screen: modelData
            
            anchors.bottom: true
            anchors.left: true
            anchors.right: true
            
            // Altura total da área de interação
            height: 85
            color: "transparent"
            
            // ExclusiveZone 0 permite que janelas fiquem atrás do dock
            exclusiveZone: 0
            
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell-dock"

            // Detector de mouse para o auto-hide
            HoverHandler {
                id: hideTrigger
            }

            Rectangle {
                id: bar
                width: parent.width - 20
                height: 70
                anchors.horizontalCenter: parent.horizontalCenter
                
                // Animação de subida e descida
                // Escondido: y = 83 (sobra 2px) | Visível: y = 5
                y: hideTrigger.hovered ? 5 : 82
                
                Behavior on y { 
                    NumberAnimation { 
                        // Duração aumentada de 300ms para 600ms para suavidade
                        duration: 600 
                        easing.type: Easing.OutCubic 
                    } 
                }
                
                color: Qt.rgba(0, 0, 0, 0.35)
                radius: 15 
                border.color: Qt.rgba(1, 1, 1, 0.225)
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 45

                    DockIcon { icon: ""; cmd: "ghostty" }
                    DockIcon { icon: ""; cmd: "firefox" }
                    DockIcon { icon: ""; cmd: "nautilus" }
                    DockIcon { icon: "󰅱"; cmd: "zed" }
                }
            }

            // Componente de Ícone
            component DockIcon : Rectangle {
                property string icon: ""
                property string cmd: ""
                
                width: 60
                height: 60
                color: "transparent"
                radius: 12

                Process {
                    id: proc
                    command: ["sh", "-c", cmd]
                }

                Text {
                    text: icon
                    font.family: "Font Awesome 6 Free"
                    font.pointSize: 24
                    color: iconHover.hovered ? "#33ccff" : "white"
                    anchors.centerIn: parent
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                HoverHandler { id: iconHover }

                TapHandler {
                    onTapped: {
                        proc.startDetached()
                    }
                }

                transform: Translate {
                    y: iconHover.hovered ? -8 : 0
                    Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                }
            }
        }
    }
}
