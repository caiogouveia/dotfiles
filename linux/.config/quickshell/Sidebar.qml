import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland

PanelWindow {
  id: sidebar

  readonly property string uiFont: "JetBrainsMono Nerd Font"
  readonly property color accent: "#85448E"

  // apps fixados, na ordem em que aparecem no dock
  readonly property var pinnedApps: [
    { name: "Terminal", icon: "com.mitchellh.ghostty", exec: "ghostty", match: "ghostty" },
    { name: "Firefox", icon: "firefox", exec: "firefox", match: "firefox" },
    { name: "Chrome", icon: "google-chrome", exec: "google-chrome-stable", match: "google-chrome" },
    { name: "Files", icon: "org.gnome.Nautilus", exec: "nautilus", match: "nautilus" },
    { name: "Zed", icon: "dev.zed.Zed", exec: "zed", match: "zed" },
    { name: "Teams", icon: "chrome-ompifgpmddkgmclendfeacglnodjjndh-Default", exec: "/opt/google/chrome/google-chrome --profile-directory=Default --app-id=ompifgpmddkgmclendfeacglnodjjndh", match: "ompifgpmddkgmclendfeacglnodjjndh" },
    { name: "Outlook", icon: "chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default", exec: "/opt/google/chrome/google-chrome --profile-directory=Default --app-id=faolnafnngnfdaknnbpnkhgohbobgegn", match: "faolnafnngnfdaknnbpnkhgohbobgegn" },
    { name: "WhatsApp", icon: "chrome-hnpfjngllnobngcgfapefoaidbinmjnm-Default", exec: "/opt/google/chrome/google-chrome --profile-directory=Default --app-id=hnpfjngllnobngcgfapefoaidbinmjnm", match: "hnpfjngllnobngcgfapefoaidbinmjnm" }
  ]

  readonly property var runningToplevels: Hyprland.toplevels ? Hyprland.toplevels.values : []

  function classOf(t) {
    return (t?.lastIpcObject?.class ?? t?.wayland?.appId ?? "").toLowerCase();
  }

  function matchesFor(key) {
    return runningToplevels.filter(t => classOf(t).includes(key));
  }

  // apps rodando que nao estao fixados, deduplicados por classe (como o Ubuntu Dock faz)
  readonly property var unpinnedRunning: {
    const seen = new Set();
    const out = [];
    for (const t of runningToplevels) {
      const cls = classOf(t);
      if (!cls || seen.has(cls)) continue;
      if (pinnedApps.some(a => cls.includes(a.match))) continue;
      seen.add(cls);
      out.push({ name: t.lastIpcObject?.class ?? cls, icon: cls, exec: "", match: cls });
    }
    return out;
  }

  anchors {
    top: true
    left: true
    bottom: true
  }

  implicitWidth: 48
  color: "transparent"

  Rectangle {
    id: content
    anchors.fill: parent
    anchors.topMargin: 0
    anchors.leftMargin: 0
    anchors.bottomMargin: 0
    anchors.rightMargin: 0
    radius: 15
    color: Qt.rgba(0, 0, 0, 0.55)
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.14)

    ColumnLayout {
      anchors.fill: parent
      anchors.topMargin: 14
      anchors.bottomMargin: 14
      spacing: 0

      Repeater {
        model: sidebar.pinnedApps
        delegate: DockIcon {
          required property var modelData
          Layout.alignment: Qt.AlignHCenter
          appName: modelData.name
          iconName: modelData.icon
          execCmd: modelData.exec
          matchKey: modelData.match
        }
      }

      Rectangle {
        visible: sidebar.unpinnedRunning.length > 0
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        implicitWidth: 34
        implicitHeight: 1
        color: Qt.rgba(1, 1, 1, 0.14)
      }

      Repeater {
        model: sidebar.unpinnedRunning
        delegate: DockIcon {
          required property var modelData
          Layout.alignment: Qt.AlignHCenter
          appName: modelData.name
          iconName: modelData.icon
          execCmd: ""
          matchKey: modelData.match
        }
      }

      Item { Layout.fillHeight: true }

      Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: 2
        implicitWidth: 34
        implicitHeight: 1
        color: Qt.rgba(1, 1, 1, 0.14)
      }

      // botao "Mostrar Aplicativos", igual ao grid do Ubuntu Dock
      Rectangle {
        id: showApps
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: 48
        implicitHeight: 48
        radius: 12
        color: showAppsHover.hovered ? Qt.rgba(1, 1, 1, 0.12) : "transparent"

        Text {
          anchors.centerIn: parent
          text: "󱕴"
          color: "white"
          font.family: sidebar.uiFont
          font.pixelSize: 20
        }

        HoverHandler { id: showAppsHover }
        TapHandler {
          onTapped: Quickshell.execDetached(["fuzzel"])
        }
      }
    }
  }

  component DockIcon: Item {
    id: dockIcon
    required property string appName
    required property string iconName
    required property string execCmd
    required property string matchKey

    readonly property var running: sidebar.matchesFor(matchKey)
    readonly property bool isRunning: running.length > 0
    readonly property bool isFocused: running.some(t => t.activated === true)

    Layout.preferredWidth: 48
    Layout.preferredHeight: 48

    // indicador de janela aberta/focada, como as pilulas do Ubuntu Dock
    Rectangle {
      width: 3
      height: dockIcon.isFocused ? 26 : (dockIcon.isRunning ? 14 : 0)
      radius: 2
      color: sidebar.accent
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left

      Behavior on height {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
      }
    }

    Rectangle {
      anchors.centerIn: parent
      width: 48
      height: 48
      radius: 12
      color: iconHover.hovered ? Qt.rgba(1, 1, 1, 0.12) : "transparent"

      IconImage {
        anchors.centerIn: parent
        implicitSize: 24
        source: Quickshell.iconPath(dockIcon.iconName, "application-x-executable")
      }

      HoverHandler { id: iconHover }

      TapHandler {
        onTapped: {
          if (dockIcon.isRunning) {
            Hyprland.dispatch("focuswindow class:^(" + dockIcon.matchKey + ")$");
          } else if (dockIcon.execCmd !== "") {
            Quickshell.execDetached(["sh", "-c", dockIcon.execCmd]);
          }
        }
      }
    }
  }
}
