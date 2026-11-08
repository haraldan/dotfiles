import QtQuick
import Quickshell.Hyprland
import qs.Ui

// The Omarchy menu's bar button (omarchy.menu's BarWidget), left-click only,
// with the gap between the button and the screen edge made clickable so the
// menu also opens from the very corner.
BarWidget {
  id: root
  moduleName: "daniel.menu"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // Exactly what Super+Space does: fire the shell's Hyprland global shortcut
  // (omarchy:menu.root), sent over Hyprland's socket with no process spawned.
  function toggleMenu() {
    Hyprland.dispatch('hl.dsp.global("omarchy:menu.root")')
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: ""
    fontFamily: "omarchy"
    onPressed: function(b) { if (b === Qt.LeftButton) root.toggleMenu() }
  }

  // Qt doesn't deliver input to a child outside its parent's bounds, so the
  // corner hit area is parented to the bar window's root item and kept
  // aligned with the button, spanning from the window edge to its left edge.
  readonly property Item windowRoot: root.Window.window ? root.Window.window.contentItem : null

  function updateCorner() {
    if (!windowRoot || !root.visible || root.width <= 0) { corner.width = 0; return }
    var p = root.mapToItem(windowRoot, 0, 0)
    corner.x = 0
    corner.y = 0
    corner.width = Math.max(0, p.x)
    corner.height = p.y * 2 + root.height
  }

  onWidthChanged: updateCorner()
  onHeightChanged: updateCorner()
  onXChanged: updateCorner()
  onWindowRootChanged: updateCorner()
  // Ancestors can move without notifying this item, so recheck now and then.
  Timer { interval: 2000; running: true; repeat: true; onTriggered: root.updateCorner() }

  MouseArea {
    id: corner
    parent: root.windowRoot || root
    z: 1000
    acceptedButtons: Qt.LeftButton
    cursorShape: Qt.PointingHandCursor
    onPressed: root.toggleMenu()
  }
}
