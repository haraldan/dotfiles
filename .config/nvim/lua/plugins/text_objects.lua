return {
	{
		"wellle/targets.vim",
    config = function ()
      -- add {} lua tables to the argument text object
      vim.cmd([[autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[([{]', 'c': '[])}]', 's': ','}]},
    \ }) ]])
    end
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

