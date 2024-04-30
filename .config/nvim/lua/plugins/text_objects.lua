return {
	{
		"wellle/targets.vim",
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		config = function()
			require("various-textobjs").setup({ useDefaultKeymaps = true })
			-- Remap sentence text objects
			vim.keymap.set({ "o", "x" }, "aS", "as", {desc = "outer Sentence"})
			vim.keymap.set({ "o", "x" }, "iS", "is", {desc = "inner Sentence"})
			-- example: `as` for outer subword, `is` for inner subword
			vim.keymap.set({ "o", "x" }, "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>', {desc = "outer subword"})
			vim.keymap.set({ "o", "x" }, "is", '<cmd>lua require("various-textobjs").subword("inner")<CR>', {desc = "inner subword"})
		end,
	},
}

