-- Alt+h/j/k/l move between splits and cross into the surrounding Herdr or tmux pane at an edge.
local function navigate(wincmd, direction, tmux_flag)
  return function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. wincmd)
    if vim.api.nvim_get_current_win() ~= win then
      return
    end
    local pane = vim.env.HERDR_PANE_ID
    if pane and pane ~= "" then
      vim.fn.system({ vim.fn.expand("~/.config/herdr/navigate.sh"), direction })
    elseif vim.env.TMUX and vim.env.TMUX ~= "" then
      vim.fn.system({ "tmux", "select-pane", tmux_flag })
    end
  end
end

vim.keymap.set("n", "<M-h>", navigate("h", "left", "-L"), { desc = "Navigate left" })
vim.keymap.set("n", "<M-j>", navigate("j", "down", "-D"), { desc = "Navigate down" })
vim.keymap.set("n", "<M-k>", navigate("k", "up", "-U"), { desc = "Navigate up" })
vim.keymap.set("n", "<M-l>", navigate("l", "right", "-R"), { desc = "Navigate right" })

-- Resize the Vim split; if nothing changed, resize the surrounding Herdr pane
-- (the plugin itself only forwards to tmux).
local function resize(command, direction)
  return function()
    local width, height = vim.fn.winwidth(0), vim.fn.winheight(0)
    vim.cmd(command)
    local herdr_pane = vim.env.HERDR_PANE_ID
    local in_tmux = vim.env.TMUX and vim.env.TMUX ~= ""
    if herdr_pane and herdr_pane ~= "" and not in_tmux
        and width == vim.fn.winwidth(0) and height == vim.fn.winheight(0) then
      vim.fn.system({ "herdr", "pane", "resize", "--pane", herdr_pane, "--direction", direction })
    end
  end
end

return {
  {
    'RyanMillerC/better-vim-tmux-resizer',
    cmd = {
      "TmuxResizeLeft",
      "TmuxResizeDown",
      "TmuxResizeUp",
      "TmuxResizeRight",
      "TmuxResizePrevious",
    },
    keys = {
      { "<M-Left>", resize("TmuxResizeLeft", "left") },
      { "<M-Down>", resize("TmuxResizeDown", "down") },
      { "<M-Up>", resize("TmuxResizeUp", "up") },
      { "<M-Right>", resize("TmuxResizeRight", "right") },
    },
    init = function()
      vim.g.tmux_resizer_no_mappings = 1
      vim.g.tmux_resizer_resize_count = 2
      vim.g.tmux_resizer_vertical_resize_count = 3
    end,

  }
}
