return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    vim.g.nvim_surround_no_normal_mappings = true
    vim.keymap.set("n", "<leader>s", "<Plug>(nvim-surround-normal)", {
        desc = "Add a surrounding pair around a motion (normal mode)",
    })
    vim.keymap.set("n", "<leader>ss", "<Plug>(nvim-surround-normal-cur)", {
        desc = "Add a surrounding pair around the current line (normal mode)",
    })
    vim.keymap.set("n", "<leader>S", "<Plug>(nvim-surround-normal-line)", {
        desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
    })
    vim.keymap.set("n", "<leader>SS", "<Plug>(nvim-surround-normal-cur-line)", {
        desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
    })
    vim.keymap.set("x", "<leader>s", "<Plug>(nvim-surround-visual)", {
        desc = "Add a surrounding pair around a visual selection",
    })
    vim.keymap.set("x", "<leader>S", "<Plug>(nvim-surround-visual-line)", {
        desc = "Add a surrounding pair around a visual selection, on new lines",
    })
    vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", {
        desc = "Delete a surrounding pair",
    })
    vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", {
        desc = "Change a surrounding pair",
    })
    vim.keymap.set("n", "cS", "<Plug>(nvim-surround-change-line)", {
        desc = "Change a surrounding pair, putting replacements on neü lines",
    })
  end,
}
