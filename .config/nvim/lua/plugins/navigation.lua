return {
	{
		"echasnovski/mini.bracketed",
		version = false,
		config = function()
			require("mini.bracketed").setup({
				buffer = { suffix = "", options = {} },
				comment = { suffix = "c", options = {} },
				indent = { suffix = "i", options = { change_type = "diff" } },
				quickfix = { suffix = "q", options = {} },
				conflict = { suffix = "", options = {} },
				diagnostic = { suffix = "", options = {} },
				file = { suffix = "", options = {} },
				jump = { suffix = "", options = {} },
				location = { suffix = "", options = {} },
				oldfile = { suffix = "", options = {} },
				treesitter = { suffix = "", options = {} },
				undo = { suffix = "", options = {} },
				window = { suffix = "", options = {} },
				yank = { suffix = "", options = {} },
			})
		end,
	},
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
        dim = true,
			})
		end,
	},
	{
		"folke/flash.nvim",
		lazy = false,
		keys = {
			{
				"<CR>",
				mode = { "n" },
				function()
					if vim.bo.buftype == "nofile" or vim.bo.buftype == "quickfix" then
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
					else
						require("flash").jump()
					end
				end,
				desc = "Flash",
			},
			{
				"<CR>",
				mode = { "x", "o" },
				function()
             require("flash").jump({jump={offset=-1}})
				end,
				desc = "Flash",
			},
			{
				"<leader><CR>",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},

			-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{
				"<C-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
		opts = {
			modes = {
				char = {
					enabled = false,
				},
			},
		},
	},
}
