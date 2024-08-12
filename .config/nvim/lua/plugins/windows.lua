return {
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      require("windows").setup({
        autowidth = { enable = false },
      })
      vim.keymap.set("n", "<C-w>z", ":WindowsMaximize<CR>")
      vim.keymap.set("n", "<C-w>=", ":WindowsEqualize<CR>")
    end,
  },
  {
    "0x00-ketsu/maximizer.nvim",
    config = function()
      require("maximizer").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
    			"dapui_watches",
    			"dapui_breakpoints",
    			"dapui_scopes",
    			"dapui_stacks",
          },
          callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', '<C-w>z', '<cmd>lua require("maximizer").toggle()<CR>', {silent = true, noremap = true})
          end,
        })
      })
    end,
  },
}
