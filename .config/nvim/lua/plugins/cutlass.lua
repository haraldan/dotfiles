return {
  "gbprod/cutlass.nvim",
  -- opts = {
  --   cut_key = "m",
  --   override_del = true,
  -- },
  config = function()
    require("cutlass").setup({
      cut_key = "m",
      override_del = true,
    })
    for i = 1, 100, 1 do -- enable m2m etc.
      vim.keymap.set("n", string.format("m%sm",tostring(i)),  string.format("d%sd",tostring(i)), {})
    end
  end,
}
