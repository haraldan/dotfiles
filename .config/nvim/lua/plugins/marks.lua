return {
  "chentoast/marks.nvim",
  config = function()
    require("marks").setup({
      default_mappings = true,
      signs = true,
      mappings = {
        next = "gm",
        prev = "gM",
      },
    })
  end,
}
