return {
	"roobert/search-replace.nvim",
	config = function()
		require("search-replace").setup({
			-- optionally override defaults
			-- default_replace_single_buffer_options = "gcI",
			-- default_replace_multi_buffer_options = "egcI",
		})

		vim.keymap.set("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>",{desc = "Replace Selection (interactive)"})
		vim.keymap.set("n", "<leader>rr", "<CMD>SearchReplaceSingleBufferOpen<CR>",{desc = "Search and replace"})
		vim.keymap.set("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>",{desc = "Replace word under cursor"})
		vim.keymap.set("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>",{desc = "Replace Word under cursor"})
		vim.keymap.set("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>",{desc = "Replace Expr under cursor"})
		vim.keymap.set("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>",{desc = "Replace file under cursor"})

    vim.keymap.set("v", "<leader>r", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>",{desc = "Replace visual selection"})
	end,
}
