return {
	{
		"linux-cultist/venv-selector.nvim",
		lazy = false,
		dependencies = {
			"neovim/nvim-lspconfig",
			{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		branch = "regexp", -- This is the regexp branch, use this for the new version
		config = function()
			require("venv-selector").setup({
				settings = {
					options = {},
				},
			})
		end,
		keys = {
			{ "<leader>fv", "<cmd>VenvSelect<cr>" },
		},
	},
	{
		"Vigemus/iron.nvim",
		ft = "python",
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")

			iron.setup({
				config = {
					-- Whether a repl should be discarded or not

					scratch_repl = false,
					-- Your repl definitions come here
					-- repl_definition = {
					--   sh = {
					--     -- Can be a table or a function that
					--     -- returns a table (see below)
					--     command = { "zsh" },
					--   },
					-- },
					-- How the repl window will be displayed
					-- See below for more information
					repl_open_cmd = view.split.vertical.botright(50),
				},

				-- Iron doesn't set keymaps by default anymore.
				-- You can set them here or manually add keymaps to the functions in iron.core
				keymaps = {
					send_motion = "<space>sc",

					visual_send = "<space>s",
					send_file = "<space>sf",
					send_line = "<space>sl",
					send_paragraph = "<space>sp",
					send_until_cursor = "<space>su",
					send_mark = "<space>sm",

					mark_motion = "<space>mc",
					mark_visual = "<space>mc",
					remove_mark = "<space>md",
					cr = "<space>s<cr>",
					interrupt = "<space>s<space>",
					exit = "<space>sq",
					clear = "<space>cl",
				},
				-- If the highlight is on, you can change how it looks
				-- For the available options, check nvim_set_hl
				highlight = {
					italic = true,
				},
				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
			})

			-- iron also has a list of commands, see :h iron-commands for all available commands
			vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
			vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
			vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
			vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
		end,
	},
}
