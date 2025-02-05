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
					options = {
						enable_default_searches = false,
					},
					search = {
						virtualenv = {
							command = "$FD '/bin/python$' ~/.virtualenvs --full-path --color never ",
						},
					},
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
					scratch_repl = true,
					repl_definition = {
						sh = {
							command = { "bash" },
						},
						python = require("iron.fts.python").ipython,
					},
					-- -- set the file type of the newly created repl to ft
					-- -- bufnr is the buffer id of the REPL and ft is the filetype of the
					-- -- language being used for the REPL.
					-- repl_filetype = function(bufnr, ft)
					-- 	return ft
					-- end,
					repl_open_cmd = view.split.vertical.botright(0.4),
				},

				keymaps = {
					send_file = "<F7>",
					send_line = "<leader>rl",
					send_paragraph = "<leader>rp",
					-- send_motion = "<leader>sc",
					-- visual_send = "<leader>s",
					-- send_until_cursor = "<leader>su",
					-- send_mark = "<leader>sm",
					-- mark_motion = "<leader>mc",
					-- mark_visual = "<leader>mc",
					-- remove_mark = "<leader>md",
					-- cr = "<leader>s<cr>",
					interrupt = "<leader>rx",
					exit = "<leader>rq",
					clear = "<leader>rc",
				},
				-- If the highlight is on, you can change how it looks
				-- For the available options, check nvim_set_hl
				highlight = {
					italic = true,
				},
				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
			})

			-- iron also has a list of commands, see :h iron-commands for all available commands
			vim.keymap.set("n", "<leader>rr", "<cmd>IronRepl<cr>")
			vim.keymap.set("n", "<leader>rR", "<cmd>IronRestart<cr>")
			vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>")
			vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>")
		end,
	},
}
