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
      vim.fn.system({ "herdr", "pane", "focus", "--direction", direction, "--pane", pane })
    elseif vim.env.TMUX and vim.env.TMUX ~= "" then
      vim.fn.system({ "tmux", "select-pane", tmux_flag })
    end
  end
end

vim.keymap.set("n", "<M-h>", navigate("h", "left", "-L"), { desc = "Navigate left" })
vim.keymap.set("n", "<M-j>", navigate("j", "down", "-D"), { desc = "Navigate down" })
vim.keymap.set("n", "<M-k>", navigate("k", "up", "-U"), { desc = "Navigate up" })
vim.keymap.set("n", "<M-l>", navigate("l", "right", "-R"), { desc = "Navigate right" })
vim.keymap.set("n", "<M-\\>", "<cmd>wincmd p<cr>", { desc = "Navigate to previous window" })

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
      { "<M-Left>",  "<cmd>TmuxResizeLeft<cr>" },
      { "<M-Down>",  "<cmd>TmuxResizeDown<cr>" },
      { "<M-Up>",    "<cmd>TmuxResizeUp<cr>"   },
      { "<M-Right>", "<cmd>TmuxResizeRight<cr>"},
    },
    init = function()
      vim.g.tmux_resizer_no_mappings = 1
      vim.g.tmux_resizer_resize_count = 2
      vim.g.tmux_resizer_vertical_resize_count = 3
    end,

  }
}
