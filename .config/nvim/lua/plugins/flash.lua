return{
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    { "<CR>", mode = { "n", "x", "o" }, function()
      if vim.bo.buftype == "nofile" or vim.bo.buftype == "quickfix"  then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
      else
        require("flash").jump()
      end
    end,
    desc = "Flash" },
    { "<leader><CR>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },

    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
