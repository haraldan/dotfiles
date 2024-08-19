return {
  "aaron-p1/virt-notes.nvim",
  config = function()
    require("virt-notes").setup({
      hl_group = "Todo",
      mappings = {
        prefix = "<Leader>n",
      },
    })
  end,
}
