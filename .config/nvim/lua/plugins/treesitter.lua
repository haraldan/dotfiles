return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter", lazy = false, branch = "master", build = ":TSUpdate" },
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				highlight = {
					enable = true,
					disable = { "tmux" },
				},
				-- indent = { enable = true },
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
						},
					},
				},
			})
		end,
	},
}
