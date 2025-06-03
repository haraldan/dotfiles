return {
	"m4xshen/hardtime.nvim",
	lazy = false,
  -- enabled = false,
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
    disable_mouse = false,
     restricted_keys = {
      ["h"] = { "n", "x" },
      ["j"] = { "n", "x" },
      ["k"] = { "n", "x" },
      ["l"] = { "n", "x" },
      ["+"] = {},
      ["gj"] = {},
      ["gk"] = {},
      ["<C-M>"] = {},
      ["<C-N>"] = {},
      ["<C-P>"] = {},
   },
  },
}
