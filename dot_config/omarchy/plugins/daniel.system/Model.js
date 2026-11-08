// Reads the System submenu out of the same JSONC files the Omarchy menu uses
// (the packaged defaults plus ~/.config/omarchy/extensions/omarchy-menu.jsonc),
// so the widget always lists exactly what Alt+F4 / Super+Escape shows.

var MENU_ID = "system"

// Same stripping rules as the menu's own parser (full-line comments and
// trailing commas).
function stripJsonc(raw) {
  return String(raw || "")
    .replace(/^\s*\/\/[^\n]*(\n|$)/gm, "")
    .replace(/,(\s*[}\]])/g, "$1")
}

// Returns an ordered array of [id, fields] pairs, or null when the text is
// not a valid menu (e.g. a file caught mid-write).
function parse(raw) {
  var stripped = stripJsonc(raw)
  if (!stripped.trim()) return []
  var parsed
  try {
    parsed = JSON.parse(stripped)
  } catch (e) {
    return null
  }
  if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed)) return null
  var source = (parsed.items && typeof parsed.items === "object" && !Array.isArray(parsed.items)) ? parsed.items : parsed
  var out = []
  for (var id in source) {
    var entry = source[id]
    if (!entry || typeof entry !== "object" || Array.isArray(entry)) continue
    out.push([id, entry])
  }
  return out
}

function parentOf(id, entry) {
  if (entry.parent !== undefined) return String(entry.parent)
  return id.indexOf(".") >= 0 ? id.split(".").slice(0, -1).join(".") : "root"
}

// Merge user fields over defaults (like the menu does) and keep the direct
// action children of the System submenu, in definition order.
function systemItems(defaultRows, userRows) {
  var merged = {}
  var order = []
  var sources = [defaultRows || [], userRows || []]
  for (var s = 0; s < sources.length; s++) {
    for (var i = 0; i < sources[s].length; i++) {
      var id = sources[s][i][0]
      var fields = sources[s][i][1]
      if (!merged[id]) { merged[id] = {}; order.push(id) }
      for (var k in fields) merged[id][k] = fields[k]
    }
  }

  var header = merged[MENU_ID] || {}
  var items = []
  for (var j = 0; j < order.length; j++) {
    var key = order[j]
    var e = merged[key]
    if (parentOf(key, e) !== MENU_ID || !e.action) continue
    items.push({
      id: key,
      icon: String(e.icon || ""),
      label: String(e.label || key),
      action: String(e.action),
      when: String(e.when || "")
    })
  }
  return { icon: String(header.icon || ""), label: String(header.label || "System"), items: items }
}

// One bash script answering every `when:` guard as "<index>:<0|1>" lines.
// The guards come from the user's own menu files, so they run with the same
// trust the menu gives them.
function guardScript(items) {
  var script = ""
  for (var i = 0; i < items.length; i++) {
    if (!items[i].when) continue
    script += "if { " + items[i].when + "; } >/dev/null 2>&1; then echo " + i + ":1; else echo " + i + ":0; fi\n"
  }
  return script
}

function parseGuards(raw) {
  var out = {}
  var lines = String(raw || "").split("\n")
  for (var i = 0; i < lines.length; i++) {
    var m = /^(\d+):([01])$/.exec(lines[i].trim())
    if (m) out[m[1]] = m[2] === "1"
  }
  return out
}
