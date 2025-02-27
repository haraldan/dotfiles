return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        highlight = {
          enable = true,
          disable = {"tmux"},
        },
        -- indent = { enable = true },
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
      })
    end
  }
}
