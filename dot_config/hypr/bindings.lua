-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Switch keyboard layout with Left Ctrl + Left Shift, pressed in either order.
-- Done here rather than with xkb's grp:lctrl_lshift_toggle, which clashes with
-- shift:both_capslock over Left Shift. release fires on key-up, and only if no
-- other key was pressed in between, so Ctrl+Shift+<key> shortcuts in apps keep
-- the current layout. non_consuming passes the modifiers through to apps.
-- On release the released key's own modifier may still be in the mask, so
-- each key is bound both with and without it.
local opts = { release = true, non_consuming = true }
o.bind("CTRL + Shift_L", "Switch keyboard layout", "hyprctl switchxkblayout all next", opts)
o.bind("SHIFT + Control_L", "Switch keyboard layout", "hyprctl switchxkblayout all next", opts)
o.bind("CTRL + SHIFT + Shift_L", "Switch keyboard layout", "hyprctl switchxkblayout all next", opts)
o.bind("CTRL + SHIFT + Control_L", "Switch keyboard layout", "hyprctl switchxkblayout all next", opts)

-- Vim-style window navigation: Super+hjkl focuses, Super+Shift+hjkl swaps.
-- The arrow-key versions stay bound. Omarchy's Super+J/K/L move to Super+Alt,
-- and the tmux keybindings menu moves from Super+Alt+K to Super+Alt+T.
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
hl.unbind("SUPER + ALT + K")

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

o.bind("SUPER + ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + ALT + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + ALT + T", "Tmux keybindings", "omarchy-menu-tmux-keybindings")

-- Super+F: full screen, Super+Z: full width, Super+Shift+F: Dolphin as the
-- file manager, Super+Ctrl+F and Super+Alt+F: nothing. Super+Ctrl+Shift+F opens
-- Dolphin in the active terminal's directory. Omarchy's tiled full screen is dropped.
hl.unbind("SUPER + F")
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + CTRL + F")
hl.unbind("SUPER + ALT + F")
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + Z", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("ALT + RETURN", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
-- Right Alt is AltGr (MOD5) in the us(intl) layout; AltGr+Enter types nothing.
o.bind("MOD5 + RETURN", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + SHIFT + F", "File manager", { launch = "dolphin --new-window" })
o.bind("SUPER + CTRL + SHIFT + F", "File manager (cwd)", 'uwsm-app -- dolphin --new-window "$(terminal-cwd)"')

-- Close window on Super+Q instead of Super+W.
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Move window to scratchpad on Super+Shift+S (replaces Google Maps) instead of Super+Alt+S.
hl.unbind("SUPER + ALT + S")
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Agent on Super+A instead of Super+Shift+Ctrl+A.
hl.unbind("SUPER + SHIFT + CTRL + A")
o.bind("SUPER + A", "Agent", "omarchy-agent --pick")

-- Super+N/P: next/previous workspace, like Super+Tab/Super+Shift+Tab (replaces
-- the pseudo window toggle on Super+P).
hl.unbind("SUPER + P")
o.bind("SUPER + N", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + P", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- Disable Super+Shift+W (was: Omawrite, uninstalled).
hl.unbind("SUPER + SHIFT + W")

-- Alt+F4 opens the system menu (lock, suspend, restart, shutdown), same as Super+Escape.
o.bind("ALT + F4", "System menu", "omarchy-menu toggle system")

-- Ctrl+H/J/K/L in the Omarchy menu act as Left/Down/Up/Right (back, down, up,
-- open), leaving plain letters for search. Bound only while the menu's layer
-- is on screen, same pattern Omarchy uses for the screenshot region picker.
local menu_binds = {}

local function send_menu_key(key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = "", key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = "", key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

hl.on("layer.opened", function(layer)
  if layer.namespace == "omarchy-menu" and #menu_binds == 0 then
    for vim_key, key in pairs({ H = "Left", J = "Down", K = "Up", L = "Right" }) do
      table.insert(menu_binds, hl.bind("CTRL + " .. vim_key, send_menu_key(key), { repeating = true, description = "Menu " .. key:lower() }))
    end
  end
end)

hl.on("layer.closed", function(layer)
  if layer.namespace == "omarchy-menu" then
    for _, keybind in ipairs(menu_binds) do
      keybind:unbind()
    end
    menu_binds = {}
  end
end)

-- Jellyfin on Super+Ctrl+J.
o.bind("SUPER + CTRL + J", "Jellyfin", { launch = "jellyfin-desktop" })
