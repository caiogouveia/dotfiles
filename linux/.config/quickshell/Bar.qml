import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower

PanelWindow {
  id: bar

  readonly property string uiFont: "JetBrainsMono Nerd Font"
  readonly property color accent: "#85448E"

  property bool calendarOpen: false

  // Workspaces: Hyprland has its own IPC module; sway doesn't, so we
  // drive it via `swaymsg` instead when running under sway.
  readonly property bool isSway: !!Quickshell.env("SWAYSOCK")
  property var swayWorkspaces: []

  function refreshSwayWorkspaces() {
    swayWsQuery.running = true;
  }

  Process {
    id: swayWsQuery
    command: ["swaymsg", "-t", "get_workspaces"]
    stdout: StdioCollector {
      onStreamFinished: {
        try { bar.swayWorkspaces = JSON.parse(text); } catch (e) {}
      }
    }
  }

  Process {
    id: swayWsSubscribe
    running: bar.isSway
    command: ["swaymsg", "-t", "subscribe", "-m", "[\"workspace\"]"]
    stdout: SplitParser {
      onRead: data => bar.refreshSwayWorkspaces()
    }
  }

  Component.onCompleted: if (bar.isSway) bar.refreshSwayWorkspaces()

  anchors {
    top: true
    left: true
    right: true
  }

  readonly property int barGap: 8

  implicitHeight: 33 + barGap
  color: "transparent"

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  property string netTypeLine: ""
  property string netSignalLine: ""
  property int netLineIdx: 0

  readonly property string netIcon: {
    if (netTypeLine.startsWith("ethernet")) return "󰀂";
    if (netTypeLine.startsWith("wifi")) {
      const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
      const sig = parseInt(netSignalLine) || 0;
      return icons[Math.min(4, Math.floor(sig / 20))];
    }
    return "󰤮";
  }

  Process {
    id: netProc
    command: ["sh", "-c", "export LC_ALL=C; nmcli -t -f TYPE,STATE dev status | grep -E '^(wifi|ethernet):connected' | head -1; nmcli -t -f active,signal dev wifi list --rescan no 2>/dev/null | awk -F: '$1==\"yes\"{print $2; exit}'"]
    stdout: SplitParser {
      onRead: data => {
        if (bar.netLineIdx === 0) bar.netTypeLine = data.trim();
        else bar.netSignalLine = data.trim();
        bar.netLineIdx++;
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      bar.netTypeLine = "";
      bar.netSignalLine = "";
      bar.netLineIdx = 0;
      netProc.running = true;
    }
  }

  property bool trayExpanded: false

  // Do Not Disturb (mako)
  property bool dndActive: false

  Process {
    id: dndProc
    command: ["makoctl", "mode"]
    stdout: SplitParser {
      onRead: data => {
        if (data.trim() === "do-not-disturb") bar.dndActive = true;
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      bar.dndActive = false;
      dndProc.running = true;
    }
  }

  // Idle / caffeine toggle (hypridle)
  property bool idleActive: true

  Process {
    id: idleProc
    command: ["pgrep", "-x", "hypridle"]
    stdout: SplitParser {
      onRead: data => {
        if (data.trim() !== "") bar.idleActive = true;
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      bar.idleActive = false;
      idleProc.running = true;
    }
  }

  // Update indicator (apt)
  property int updateCount: 0

  Process {
    id: updateProc
    command: ["sh", "-c", "apt list --upgradable 2>/dev/null | wc -l"]
    stdout: SplitParser {
      onRead: data => bar.updateCount = parseInt(data.trim()) || 0
    }
  }

  Timer {
    interval: 600000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: updateProc.running = true
  }

  Rectangle {
    id: content
    anchors.fill: parent
    anchors.topMargin: 0
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    anchors.bottomMargin: bar.barGap
    radius: 0
    color: Qt.rgba(0, 0, 0, 0.70)
    anchors.bottom: parent.bottom

    Rectangle {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      height: 1
      color: Qt.rgba(1, 1, 1, 0.14)
    }

    RowLayout {
      anchors.left: parent.left
      anchors.leftMargin: 15
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      // terminal launcher
      Rectangle {
        radius: 15
        color: "transparent"
        implicitWidth: termLabel.implicitWidth + 20
        implicitHeight: 30

        Text {
          id: termLabel
          anchors.centerIn: parent
          text: ""
          color: "white"
          font.family: bar.uiFont
          font.pixelSize: 16
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Quickshell.execDetached(["ghostty"])
        }
      }

      // workspaces pill
      Rectangle {
        radius: 15
        color: Qt.rgba(1, 1, 1, 0.1)
        implicitHeight: 30
        implicitWidth: wsRow.implicitWidth + 10

        RowLayout {
          id: wsRow
          anchors.centerIn: parent
          spacing: 2

          Repeater {
            model: [1, 2, 3]
            delegate: Rectangle {
              required property int modelData
              readonly property var wsIcons: ({ 1: "一", 2: "二", 3: "三" })
              readonly property bool active: bar.isSway
                ? bar.swayWorkspaces.some(w => w.num === modelData && w.focused)
                : Hyprland.workspaces.values.some(w => w.id === modelData && w.active)
              radius: 15
              implicitWidth: 50
              implicitHeight: 26
              color: active ? "#85448E" : "transparent"

              Text {
                anchors.centerIn: parent
                text: parent.wsIcons[parent.modelData] ?? parent.modelData
                color: "white"
                font.family: bar.uiFont
                font.pixelSize: 14
                font.bold: true
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.isSway
                  ? Quickshell.execDetached(["swaymsg", "workspace", "number", String(parent.modelData)])
                  : Hyprland.dispatch("workspace " + parent.modelData)
              }
            }
          }
        }
      }
    }

    RowLayout {
      anchors.right: parent.right
      anchors.rightMargin: 15
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      // tray (recolhível)
      RowLayout {
        spacing: 6

        Rectangle {
          implicitWidth: 20
          implicitHeight: 30
          color: "transparent"

          Text {
            anchors.centerIn: parent
            text: bar.trayExpanded ? "‹" : "›"
            color: "white"
            font.pixelSize: 16
            font.bold: true
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: bar.trayExpanded = !bar.trayExpanded
          }
        }

        RowLayout {
          visible: bar.trayExpanded
          spacing: 10

          Repeater {
            model: SystemTray.items

            delegate: IconImage {
              required property var modelData
              implicitSize: 20
              source: modelData.icon

              MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                  if (mouse.button === Qt.LeftButton) modelData.activate();
                  else modelData.display();
                }
              }
            }
          }
        }
      }

      // update indicator
      Rectangle {
        visible: bar.updateCount > 0
        color: "transparent"
        implicitWidth: updateLabel.implicitWidth + 10
        implicitHeight: 30

        Text {
          id: updateLabel
          anchors.centerIn: parent
          text: "↑ " + bar.updateCount
          color: "#7fd97f"
          font.family: bar.uiFont
          font.pixelSize: 14
          font.bold: true
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Quickshell.execDetached(["ghostty", "-e", "sh", "-c", "sudo apt update && sudo apt upgrade"])
        }
      }

      // network
      Rectangle {
        color: "transparent"
        implicitWidth: netLabel.implicitWidth + 10
        implicitHeight: 30

        Text {
          id: netLabel
          anchors.centerIn: parent
          text: bar.netIcon
          color: "white"
          font.family: bar.uiFont
          font.pixelSize: 16
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Quickshell.execDetached(["nm-connection-editor"])
        }
      }

      // volume
      Rectangle {
        color: "transparent"
        implicitWidth: volLabel.implicitWidth + 10
        implicitHeight: 30

        Text {
          id: volLabel
          anchors.centerIn: parent
          color: "#ffa000"
          font.family: bar.uiFont
          font.pixelSize: 14
          font.bold: true
          text: {
            const sink = Pipewire.defaultAudioSink;
            if (!sink || !sink.audio) return "vol --";
            if (sink.audio.muted) return "vol muted";
            return "vol " + Math.round(sink.audio.volume * 100) + "%";
          }
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton
          onClicked: {
            const sink = Pipewire.defaultAudioSink;
            if (sink && sink.audio) sink.audio.muted = !sink.audio.muted;
          }
          onWheel: wheel => {
            const sink = Pipewire.defaultAudioSink;
            if (!sink || !sink.audio) return;
            const step = 0.05;
            const delta = wheel.angleDelta.y > 0 ? step : -step;
            sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + delta));
          }
        }
      }

      // cpu / btop
      Rectangle {
        color: "transparent"
        implicitWidth: cpuLabel.implicitWidth + 10
        implicitHeight: 30

        Text {
          id: cpuLabel
          anchors.centerIn: parent
          text: "󰍛"
          color: "white"
          font.family: bar.uiFont
          font.pixelSize: 16
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Quickshell.execDetached(["ghostty", "-e", "btop"])
        }
      }

      // do not disturb
      Rectangle {
        color: "transparent"
        implicitWidth: dndLabel.implicitWidth + 10
        implicitHeight: 30

        Text {
          id: dndLabel
          anchors.centerIn: parent
          text: bar.dndActive ? "󰂛" : "󰂚"
          color: bar.dndActive ? bar.accent : "white"
          font.family: bar.uiFont
          font.pixelSize: 16
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            Quickshell.execDetached(["makoctl", "mode", "-t", "do-not-disturb"]);
            bar.dndActive = !bar.dndActive;
          }
        }
      }

      // idle / caffeine
      Rectangle {
        color: "transparent"
        implicitWidth: idleLabel.implicitWidth + 10
        implicitHeight: 30

        Text {
          id: idleLabel
          anchors.centerIn: parent
          text: "󰛊"
          color: bar.idleActive ? "white" : "#ffa000"
          font.family: bar.uiFont
          font.pixelSize: 16
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (bar.idleActive) {
              Quickshell.execDetached(["pkill", "-x", "hypridle"]);
            } else {
              Quickshell.execDetached(["hypridle"]);
            }
            bar.idleActive = !bar.idleActive;
          }
        }
      }

      // battery
      Rectangle {
        visible: UPower.displayDevice !== null && UPower.displayDevice.isLaptopBattery
        color: "transparent"
        implicitWidth: battLabel.implicitWidth + 10
        implicitHeight: 30

        Text {
          id: battLabel
          anchors.centerIn: parent
          color: "white"
          font.family: bar.uiFont
          font.pixelSize: 14
          font.bold: true
          text: UPower.displayDevice ? Math.round(UPower.displayDevice.percentage * 100) + "%" : ""
        }
      }

      // clock
      Rectangle {
        radius: 15
        color: Qt.rgba(0, 0, 0, 0.55)
        border.width: 2
        border.color: Qt.rgba(0x85 / 255, 0x44 / 255, 0x8e / 255, 0.85)
        implicitHeight: 30
        implicitWidth: clockLabel.implicitWidth + 20

        Text {
          id: clockLabel
          anchors.centerIn: parent
          color: "white"
          font.family: bar.uiFont
          font.pixelSize: 14
          font.bold: true
          text: Qt.formatDateTime(clock.date, "ddd dd/MM/yyyy - HH:mm:ss")
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (!bar.calendarOpen) calendarPopup.viewDate = new Date();
            bar.calendarOpen = !bar.calendarOpen;
          }
        }
      }

      // power menu
      Rectangle {
        color: "transparent"
        implicitWidth: powerLabel.implicitWidth + 20
        implicitHeight: 30

        Text {
          id: powerLabel
          anchors.centerIn: parent
          text: "⏻"
          color: "white"
          font.family: bar.uiFont
          font.pixelSize: 16
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Quickshell.execDetached([Quickshell.env("HOME") + "/.local/bin/power-menu.sh"])
        }
      }
    }
  }

  PanelWindow {
    id: calendarPopup
    visible: bar.calendarOpen

    property date viewDate: new Date()
    readonly property date today: new Date()

    readonly property var dayNames: ["D", "S", "T", "Q", "Q", "S", "S"]
    readonly property var monthNames: [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ]

    readonly property var cells: {
      const y = viewDate.getFullYear();
      const m = viewDate.getMonth();
      const firstDow = new Date(y, m, 1).getDay();
      const totalDays = new Date(y, m + 1, 0).getDate();
      const prevTotalDays = new Date(y, m, 0).getDate();

      const out = [];
      for (let i = 0; i < firstDow; i++) {
        out.push({ day: prevTotalDays - firstDow + 1 + i, current: false, isToday: false });
      }
      for (let d = 1; d <= totalDays; d++) {
        const isToday = d === today.getDate() && m === today.getMonth() && y === today.getFullYear();
        out.push({ day: d, current: true, isToday: isToday });
      }
      let nextDay = 1;
      while (out.length < 42) {
        out.push({ day: nextDay, current: false, isToday: false });
        nextDay++;
      }
      return out;
    }

    function monthLabel() {
      return monthNames[viewDate.getMonth()] + " " + viewDate.getFullYear();
    }

    anchors {
      top: true
      right: true
    }

    margins {
      top: bar.implicitHeight + 10
      right: 20
    }

    implicitWidth: 260
    implicitHeight: 300
    color: "transparent"
    exclusiveZone: -1

    Rectangle {
      anchors.fill: parent
      radius: 15
      color: Qt.rgba(0, 0, 0, 0.85)
      border.width: 1
      border.color: Qt.rgba(1, 1, 1, 0.14)

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        RowLayout {
          Layout.fillWidth: true

          Text {
            text: "‹"
            color: "white"
            font.pixelSize: 18
            font.bold: true

            TapHandler {
              onTapped: calendarPopup.viewDate = new Date(calendarPopup.viewDate.getFullYear(), calendarPopup.viewDate.getMonth() - 1, 1)
            }
          }

          Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: calendarPopup.monthLabel()
            color: "white"
            font.family: bar.uiFont
            font.pixelSize: 15
            font.bold: true
          }

          Text {
            text: "›"
            color: "white"
            font.pixelSize: 18
            font.bold: true

            TapHandler {
              onTapped: calendarPopup.viewDate = new Date(calendarPopup.viewDate.getFullYear(), calendarPopup.viewDate.getMonth() + 1, 1)
            }
          }
        }

        GridLayout {
          Layout.fillWidth: true
          columns: 7
          rowSpacing: 6
          columnSpacing: 0

          Repeater {
            model: calendarPopup.dayNames
            delegate: Text {
              required property string modelData
              Layout.preferredWidth: 32
              horizontalAlignment: Text.AlignHCenter
              text: modelData
              color: Qt.rgba(1, 1, 1, 0.5)
              font.family: bar.uiFont
              font.pixelSize: 12
              font.bold: true
            }
          }

          Repeater {
            model: calendarPopup.cells
            delegate: Rectangle {
              required property var modelData
              Layout.preferredWidth: 32
              Layout.preferredHeight: 28
              radius: 8
              color: modelData.isToday ? bar.accent : "transparent"

              Text {
                anchors.centerIn: parent
                text: modelData.day
                color: modelData.current ? "white" : Qt.rgba(1, 1, 1, 0.3)
                font.family: bar.uiFont
                font.pixelSize: 12
                font.bold: modelData.isToday
              }
            }
          }
        }
      }
    }
  }
}
