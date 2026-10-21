-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Personal overrides of Omarchy commands live in ~/.local/lib/omarchy-overrides.
-- Omarchy puts its own bin dir first on PATH, so put the overrides ahead of it.
do
  local overrides = os.getenv("HOME") .. "/.local/lib/omarchy-overrides"
  local omarchy_bin = (os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/bin"
  local path = { overrides, omarchy_bin }
  for entry in (os.getenv("PATH") or "/usr/local/bin:/usr/bin"):gmatch("[^:]+") do
    if entry ~= overrides and entry ~= omarchy_bin then table.insert(path, entry) end
  end
  hl.env("PATH", table.concat(path, ":"))
end

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Jellyfin Desktop only inhibits idle via org.freedesktop.ScreenSaver, which nothing
-- answers on Omarchy 4.0 yet (see omacom/omarchy#13359). Remove once that lands.
o.window("(?i).*jellyfin.*", { idle_inhibit = "focus" })

-- Added by hyprmoncfg: its generated monitor rules load last, so nothing before this can override the applied layout.
do local path = os.getenv("HOME") .. "/.config/hypr/hyprmoncfg-monitors.lua"; local file = io.open(path, "r"); if file then file:close(); dofile(path) end end
