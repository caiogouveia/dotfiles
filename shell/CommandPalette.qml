import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

// Command palette estilo Omarchy: um atalho abre uma lista pesquisavel
// com apps instalados + acoes de sistema (lock, reboot, etc). Acionado
// via IpcHandler (target "palette") a partir de um bind do Hyprland, ver
// `qs -p ~/DEV/dotfiles/shell ipc call palette toggle`.
//
// id nao pode ser "palette": Item/Window ja tem uma property nativa
// chamada `palette` (tema do Qt Quick), e ela vence na resolucao de escopo
// dentro dos delegates, entao `palette.algumaCoisa` silenciosamente virava
// undefined em vez de referenciar a raiz.
PanelWindow {
  id: root

  readonly property string uiFont: "JetBrainsMono Nerd Font"
  readonly property color accent: "#85448E"

  property bool paletteOpen: false
  property int selectedIndex: 0

  // Hyprland has its own IPC/lock tooling; sway uses swaymsg/swaylock instead.
  readonly property bool isSway: !!Quickshell.env("SWAYSOCK")

  readonly property var systemActions: root.isSway ? [
    { id: "lock", icon: "󰌾", label: "Bloquear", exec: ["swaylock", "-f", "-c", "000000"] },
    { id: "reload-sway", icon: "󰑐", label: "Recarregar Sway", exec: ["swaymsg", "reload"] },
    { id: "reload-shell", icon: "󰑓", label: "Recarregar Shell", exec: ["sh", "-c", "pkill -x quickshell; exec ~/DEV/dotfiles/scripts/run-shell.sh"] },
    { id: "logout", icon: "󰍃", label: "Sair", exec: ["swaymsg", "exit"] },
    { id: "reboot", icon: "󰜉", label: "Reiniciar", exec: ["systemctl", "reboot"] },
    { id: "shutdown", icon: "󰐥", label: "Desligar", exec: ["systemctl", "poweroff"] }
  ] : [
    { id: "lock", icon: "󰌾", label: "Bloquear", exec: ["hyprlock"] },
    { id: "reload-hypr", icon: "󰑐", label: "Recarregar Hyprland", exec: ["hyprctl", "reload"] },
    { id: "reload-shell", icon: "󰑓", label: "Recarregar Shell", exec: ["sh", "-c", "pkill -x quickshell; exec ~/DEV/dotfiles/scripts/run-shell.sh"] },
    { id: "logout", icon: "󰍃", label: "Sair", exec: ["hyprctl", "dispatch", "exit"] },
    { id: "reboot", icon: "󰜉", label: "Reiniciar", exec: ["systemctl", "reboot"] },
    { id: "shutdown", icon: "󰐥", label: "Desligar", exec: ["systemctl", "poweroff"] }
  ]

  function actionRows() {
    const out = [];
    for (const a of root.systemActions)
      out.push({ id: "action:" + a.id, icon: a.icon, label: a.label, kind: "action", exec: a.exec, entry: null });
    return out;
  }

  function appRows() {
    const apps = DesktopEntries.applications.values || [];
    const out = [];
    for (const e of apps) {
      if (e.noDisplay) continue;
      out.push({ id: "app:" + e.id, icon: e.icon, label: e.name, kind: "app", exec: [], entry: e });
    }
    return out;
  }

  readonly property var filteredRows: {
    const q = searchInput.text.trim().toLowerCase();
    const rows = root.actionRows().concat(root.appRows());
    if (!q) return rows.slice(0, 60);

    const scored = [];
    for (const r of rows) {
      const label = r.label.toLowerCase();
      const idx = label.indexOf(q);
      if (idx === -1) continue;
      const score = label === q ? 0 : (idx === 0 ? 1 : 2);
      scored.push({ row: r, score: score });
    }
    scored.sort((a, b) => a.score - b.score);
    return scored.slice(0, 60).map(s => s.row);
  }

  onFilteredRowsChanged: root.selectedIndex = 0
  onSelectedIndexChanged: resultList.positionViewAtIndex(root.selectedIndex, ListView.Contain)

  function open() {
    searchInput.text = "";
    root.selectedIndex = 0;
    root.paletteOpen = true;
  }

  function close() {
    root.paletteOpen = false;
  }

  function toggle() {
    if (root.paletteOpen) root.close();
    else root.open();
  }

  function activateRow(row) {
    if (!row) return;
    if (row.kind === "app" && row.entry) row.entry.execute();
    else if (row.exec && row.exec.length > 0) Quickshell.execDetached(row.exec);
    root.close();
  }

  visible: paletteOpen
  color: "transparent"
  exclusiveZone: -1

  WlrLayershell.namespace: "command-palette"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  onVisibleChanged: if (visible) searchInput.forceActiveFocus()

  IpcHandler {
    target: "palette"

    function toggle(): void { root.toggle() }
    function open(): void { root.open() }
    function close(): void { root.close() }
  }

  // scrim - clica fora pra fechar
  Rectangle {
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.35)

    MouseArea {
      anchors.fill: parent
      onClicked: root.close()
    }

    // card
    Rectangle {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: -80
      width: 560
      implicitHeight: cardLayout.implicitHeight + 24
      radius: 18
      color: Qt.rgba(0, 0, 0, 0.85)
      border.width: 3
      border.color: Qt.rgba(1, 1, 1, 0.22)

      // impede que o clique no card feche o overlay (nao propaga pro scrim)
      MouseArea { anchors.fill: parent }

      ColumnLayout {
        id: cardLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 12
        spacing: 8

        Rectangle {
          Layout.fillWidth: true
          implicitHeight: 42
          radius: 12
          color: Qt.rgba(1, 1, 1, 0.08)

          Text {
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            text: "Buscar apps ou ações..."
            color: Qt.rgba(1, 1, 1, 0.4)
            font.family: root.uiFont
            font.pixelSize: 14
            visible: searchInput.text.length === 0
          }

          TextInput {
            id: searchInput
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.family: root.uiFont
            font.pixelSize: 14
            selectByMouse: true

            Keys.onPressed: event => {
              if (event.key === Qt.Key_Escape) {
                root.close();
                event.accepted = true;
              } else if (event.key === Qt.Key_Down) {
                root.selectedIndex = Math.min(root.selectedIndex + 1, root.filteredRows.length - 1);
                event.accepted = true;
              } else if (event.key === Qt.Key_Up) {
                root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                event.accepted = true;
              } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                root.activateRow(root.filteredRows[root.selectedIndex]);
                event.accepted = true;
              }
            }
          }
        }

        ListView {
          id: resultList
          Layout.fillWidth: true
          implicitHeight: 9 * 46
          clip: true
          interactive: true
          boundsBehavior: Flickable.StopAtBounds
          model: root.filteredRows

          delegate: Rectangle {
            id: row
            required property var modelData
            required property int index
            width: ListView.view.width
            height: 46
            radius: 10
            color: row.index === root.selectedIndex ? root.accent : "transparent"

            RowLayout {
              anchors.fill: parent
              anchors.leftMargin: 10
              anchors.rightMargin: 10
              spacing: 10

              IconImage {
                visible: row.modelData.kind === "app"
                Layout.preferredWidth: 22
                Layout.preferredHeight: 22
                source: row.modelData.kind === "app" ? Quickshell.iconPath(row.modelData.icon, true) : ""
              }

              Text {
                visible: row.modelData.kind === "action"
                Layout.preferredWidth: 22
                horizontalAlignment: Text.AlignHCenter
                text: row.modelData.icon
                color: "white"
                font.family: root.uiFont
                font.pixelSize: 16
              }

              Text {
                Layout.fillWidth: true
                text: row.modelData.label
                color: "white"
                font.family: root.uiFont
                font.pixelSize: 14
                elide: Text.ElideRight
              }
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: root.activateRow(row.modelData)
              onEntered: root.selectedIndex = row.index
              hoverEnabled: true
            }
          }
        }
      }
    }
  }
}
