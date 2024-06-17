return {
  "gbprod/cutlass.nvim",
  -- enabled = false,
  config = function()
    require("cutlass").setup({
      cut_key = "<leader>d",
      override_del = true,
    })

    -- vim.keymap.set("n", "<leader>m", "m", { desc = "Set mark" })

    -- for i = 1, 100, 1 do -- enable m2m etc.
    --   vim.keymap.set("n", string.format("m%sm",tostring(i)),  string.format("d%sd",tostring(i)), {})
    -- end
  end,
}
