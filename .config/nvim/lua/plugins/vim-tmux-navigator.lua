return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<M-h>",  "<cmd>TmuxNavigateLeft<cr>" },
      { "<M-j>",  "<cmd>TmuxNavigateDown<cr>" },
      { "<M-k>",  "<cmd>TmuxNavigateUp<cr>" },
      { "<M-l>",  "<cmd>TmuxNavigateRight<cr>" },
      { "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
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
