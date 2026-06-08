return {
	{
		"echasnovski/mini.ai",
		version = false,
    config = true,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		config = function()
			require("various-textobjs").setup({
				keymaps = {
					useDefaults = true,
          disabledDefaults = {"in","an", "iN","aN","r"}, -- conflicting with mini.ai "next" and remote flash
				},
			})
			-- Remap sentence text objects
			vim.keymap.set({ "o", "x" }, "aS", "as", { desc = "outer Sentence" })
			vim.keymap.set({ "o", "x" }, "iS", "is", { desc = "inner Sentence" })
			-- example: `as` for outer subword, `is` for inner subword
			vim.keymap.set( { "o", "x" }, "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>', { desc = "outer subword" })
			vim.keymap.set( { "o", "x" }, "is", '<cmd>lua require("various-textobjs").subword("inner")<CR>', { desc = "inner subword" })
      -- d for "digit"
			vim.keymap.set( { "o", "x" }, "ad", '<cmd>lua require("various-textobjs").number("outer")<CR>', { desc = "outer number" })
			vim.keymap.set( { "o", "x" }, "id", '<cmd>lua require("various-textobjs").number("inner")<CR>', { desc = "inner number" })
		end,
	},
}
