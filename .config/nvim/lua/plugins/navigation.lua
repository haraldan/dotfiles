return {
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
				layout = {
					-- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
					max_width = { 40, 0.2 },
					width = nil,
					min_width = 10,
					-- Enum: prefer_right, prefer_left, right, left, float
					default_direction = "prefer_left",
					--   edge   - open aerial at the far right/left of the editor
					--   window - open aerial to the right/left of the current window
					placement = "window",
					-- When the symbols change, resize the aerial window (within min/max constraints) to fit
					resize_to_content = true,
					-- Preserve window size equality with (:help CTRL-W_=)
					preserve_equality = false,
				},
				nav = {
					-- Jump to symbol in source window when the cursor moves
					autojump = false,
					-- Show a preview of the code in the right column, when there are no child symbols
					preview = false,
					-- Keymaps in the nav window
					keymaps = {
						["q"] = "actions.close",
					},
				},
			})
			vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
			vim.keymap.set("n", "<leader>fn", "<cmd>AerialNavToggle<CR>")
		end,
	},
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
		"chrisgrieser/nvim-spider",
		keys = {
			-- normal mode
			-- { "w", "<cmd>lua require('spider').motion('w',{ skipInsignificantPunctuation = true, subwordMovement = false})<CR>", mode = { "n", "o", "x" } },
			-- { "e", "<cmd>lua require('spider').motion('e',{ skipInsignificantPunctuation = true, subwordMovement = false})<CR>", mode = { "n", "o", "x" } },
			-- { "b", "<cmd>lua require('spider').motion('b',{ skipInsignificantPunctuation = true, subwordMovement = false})<CR>", mode = { "n", "o", "x" } },
			{ "\\", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
			{ "|", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
			{ "q", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
			-- insert mode
			{
				"<C-f>",
				"<Esc>l<cmd>lua require('spider').motion('w',{ skipInsignificantPunctuation = true, subwordMovement = false})<CR>i",
				mode = { "i" },
			},
			{
				"<C-b>",
				"<Esc><cmd>lua require('spider').motion('b',{ skipInsignificantPunctuation = true, subwordMovement = false})<CR>i",
				mode = { "i" },
			},
		},
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
					require("flash").jump({ jump = { offset = -1 } })
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
