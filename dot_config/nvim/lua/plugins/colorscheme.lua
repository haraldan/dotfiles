return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
	{ "robertmeta/nofrils" },
	{
		"ntk148v/komau.vim",
		config = function()
			require("komau").setup({
				style = "light",
				-- Drop Visual's foreground so selected text keeps its own color
				-- (lets the red telegram_delete mark show through the selection).
				templates = {
					function(colors)
						return { Visual = { fg = colors.none } }
					end,
				},
			})
      -- vim.cmd.colorscheme('komau')
		end,
	},
}
