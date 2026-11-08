import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import qs.Ui
import "Model.js" as Model

// Bar power button whose panel lists the Omarchy menu's System submenu
// (lock, suspend, logout, reboot, shutdown, ...), read live from the menu
// JSONC files so overrides in omarchy-menu.jsonc apply here too.
Panel {
  id: root
  moduleName: "daniel.system"
  ipcTarget: "daniel.system"

  property string omarchyPath: Quickshell.env("OMARCHY_PATH") || "/usr/share/omarchy"
  property var defaultRows: []
  property var userRows: []
  property var menu: Model.systemItems(defaultRows, userRows)
  property var guards: ({})
  property bool guardsReady: false
  property int cursor: 0
  property bool cursorActive: false

  // Rows without a `when:` show immediately; guarded rows wait for their answer.
  readonly property var visibleItems: {
    var out = []
    for (var i = 0; i < menu.items.length; i++) {
      var item = menu.items[i]
      if (!item.when || guards[String(i)] === true) out.push(item)
    }
    return out
  }

  function evaluateGuards() {
    var script = Model.guardScript(menu.items)
    if (!script) { guards = ({}); guardsReady = true; return }
    if (guardProc.running) return
    guardProc.command = ["bash", "-lc", script]
    guardProc.running = true
  }

  function activate(item) {
    if (!item || !item.action) return
    root.close()
    Util.execDetached(item.action)
  }

  function moveCursor(delta) {
    var n = visibleItems.length
    if (n === 0) return
    if (!cursorActive) { cursorActive = true; return }
    cursor = (cursor + delta + n) % n
  }

  onMenuChanged: evaluateGuards()
  onOpenedChanged: {
    if (opened) {
      cursor = 0
      cursorActive = false
      evaluateGuards()
    }
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  FileView {
    path: root.omarchyPath + "/default/omarchy/omarchy-menu.jsonc"
    watchChanges: true
    printErrors: false
    onLoaded: { var rows = Model.parse(text()); if (rows && rows.length) root.defaultRows = rows }
    onFileChanged: reload()
  }

  FileView {
    path: Quickshell.env("HOME") + "/.config/omarchy/extensions/omarchy-menu.jsonc"
    watchChanges: true
    printErrors: false
    onLoaded: { var rows = Model.parse(text()); if (rows) root.userRows = rows }
    onLoadFailed: root.userRows = []
    onFileChanged: reload()
  }

  Process {
    id: guardProc
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: { root.guards = Model.parseGuards(text); root.guardsReady = true }
    }
  }

  // The bar keeps a fixed gap between the last widget and the screen edge.
  // Cover that gap with a hit area so the button also opens from the very
  // corner. Qt doesn't deliver input to a child outside its parent's bounds,
  // so the area is parented to the bar window's root item and kept aligned
  // with the button, spanning from its right edge to the window edge.
  readonly property Item windowRoot: root.Window.window ? root.Window.window.contentItem : null

  function updateCorner() {
    if (!windowRoot || !root.visible || root.width <= 0) { corner.width = 0; return }
    var p = root.mapToItem(windowRoot, 0, 0)
    corner.x = p.x + root.width
    corner.y = 0
    corner.width = Math.max(0, windowRoot.width - corner.x)
    corner.height = p.y * 2 + root.height
  }

  onWidthChanged: updateCorner()
  onHeightChanged: updateCorner()
  onXChanged: updateCorner()
  onWindowRootChanged: updateCorner()
  Connections {
    target: root.windowRoot
    function onWidthChanged() { root.updateCorner() }
  }
  // Ancestors can move without notifying this item (layout reflows,
  // widgets added to the right section), so recheck now and then too.
  Timer { interval: 2000; running: true; repeat: true; onTriggered: root.updateCorner() }

  MouseArea {
    id: corner
    parent: root.windowRoot || root
    z: 1000
    acceptedButtons: Qt.LeftButton
    cursorShape: Qt.PointingHandCursor
    onClicked: root.toggle()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.menu.icon || "󰐥"
    tooltipText: ""
    onPressed: function(b) { root.toggle() }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: panel.loadedContent
    contentWidth: panel.fittedContentWidth(Style.space(280))
    contentHeight: panel.fittedContentHeight(panel.loadedContentHeight)

    content: PanelKeyCatcher {
      anchors.fill: parent
      implicitHeight: column.implicitHeight
      onMoveRequested: function(dx, dy) { root.moveCursor(dy !== 0 ? dy : dx) }
      onActivateRequested: if (root.cursorActive) root.activate(root.visibleItems[root.cursor])
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(6)

        Repeater {
          model: root.visibleItems
          Button {
            required property var modelData
            required property int index
            width: column.width
            leftAlign: true
            iconText: modelData.icon
            iconSize: Math.round(Style.font.display * 0.85)
            text: modelData.label
            fontSize: Style.font.title
            foreground: root.bar.foreground
            fontFamily: root.bar.fontFamily
            horizontalPadding: Style.spacing.controlPaddingX + Style.space(8)
            verticalPadding: Style.spacing.controlPaddingY + Style.space(7)
            hasCursor: root.cursorActive && root.cursor === index
            onClicked: root.activate(modelData)
            onHovered: function(h) {
              if (h) { root.cursorActive = true; root.cursor = index }
            }
          }
        }
      }
    }
  }
}
