return {
  "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
  config = function()
    require("toggle_lsp_diagnostics").init()
    vim.keymap.set("n", "<leader>lt", ":ToggleDiag<CR>", { desc = "[T]oggle [L]SP " })
  end,
}
