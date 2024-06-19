return {
	"anuvyklack/windows.nvim",
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
	config = function()
		vim.o.winwidth = 10
		vim.o.winminwidth = 10
		require("windows").setup({
			autowidth = { enable = false },
		})
    vim.keymap.set('n', '<C-w>z',  ':WindowsMaximize<CR>')
    vim.keymap.set('n', '<C-w>=',  ':WindowsEqualize<CR>')
	end,
}
