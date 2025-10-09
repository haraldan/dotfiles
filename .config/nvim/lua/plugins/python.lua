return {
	"linux-cultist/venv-selector.nvim",
	lazy = false,
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
	},
	config = function()
		require("venv-selector").setup({
				options = {
					enable_default_searches = false,
				},
				search = {
					virtualenv = {
						command = "$FD '/bin/python$' ~/.virtualenvs --full-path --color never ",
					},
				},
		})
	end,
	keys = {
		{ "<leader>fv", "<cmd>VenvSelect<cr>" },
	},
}
