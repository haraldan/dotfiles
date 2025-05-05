return {
	"folke/which-key.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"echasnovski/mini.icons",
	},
	event = "VeryLazy",
	config = function()
		require("which-key").add({
			{ "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
		})
	end,
}
