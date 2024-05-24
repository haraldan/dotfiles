return {
  "gbprod/cutlass.nvim",
  enabled = false,
  -- opts = {
  --   cut_key = "m",
  --   override_del = true,
  -- },
  config = function()
    require("cutlass").setup({
      cut_key = "m",
      override_del = true,
    })

    -- change mark shortcut to leader-m, since m is now for cutting
    vim.keymap.set("n", "<leader>m", "m", { desc = "Set mark" })

    for i = 1, 100, 1 do -- enable m2m etc.
      vim.keymap.set("n", string.format("m%sm",tostring(i)),  string.format("d%sd",tostring(i)), {})
    end
  end,
}
