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
		"jpalardy/vim-slime",
		dependencies = {
			"linux-cultist/venv-selector.nvim",
		},
    ft = "python",
		init = function()
			vim.g.slime_no_mappings = 1
			vim.g.slime_target = "tmux"
			vim.g.slime_dont_ask_default = 1
			vim.g.slime_bracketed_paste = 1
			vim.cmd([[let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}]])
		end,
		config = function()
			local function update_tmux_pane_id()
				local pane_id = vim.fn.system("~/.tmux/tmux_get_ipython_pane_id.sh")
				local slime_config = '{"socket_name": "default", "target_pane": "' .. pane_id:sub(1, -2) .. '"}'
				vim.cmd([[let g:slime_default_config =]] .. slime_config)
				vim.cmd([[let b:slime_config =]] .. slime_config)
			end

			local function open_ipython_split()
				local venv = require("venv-selector").venv()
				vim.cmd("silent !~/.tmux/tmux_ipython_split.sh " .. venv .. "/bin/ipython --no-autoindent")
				update_tmux_pane_id()
			end
			local function close_ipython_split()
				vim.cmd("silent !~/.tmux/tmux_ipython_close.sh")
			end

			vim.keymap.set("n", "<leader>ii", open_ipython_split, { desc = "Open ipython REPL", silent = true })
			vim.keymap.set( "n", "<leader>iq", close_ipython_split, { desc = "Close Ipython REPL", silent = true })

			vim.keymap.set("n", "<leader>ix", function()
				vim.cmd("SlimeSend1 %reset -f")
			end, { desc = "Reset ipython REPL", silent = true })

			vim.keymap.set("n", "<leader>ir", function()
        close_ipython_split()
        open_ipython_split()
			end, { desc = "Restart ipython REPL", silent = true })

			vim.keymap.set("n", "<leader>ic", function()
				vim.cmd("SlimeSend1 clear")
			end, { desc = "Clear ipython REPL", silent = true })

			vim.keymap.set("n", "<F7>", function()
				open_ipython_split()
				vim.cmd("%SlimeSend")
			end, { desc = "Send buffer to ipython", silent = true })

			vim.keymap.set("n", "<leader>ib", function()
				open_ipython_split()
				vim.cmd("%SlimeSend")
			end, { desc = "Send buffer to ipython", silent = true })

			vim.keymap.set("n", "<leader>il", function()
				open_ipython_split()
				vim.api.nvim_feedkeys( vim.api.nvim_replace_termcodes("<Plug>SlimeLineSend", true, true, true), "m", true)
			end, { desc = "Send line to ipython" })

			vim.keymap.set("v", "<F7>", function()
				open_ipython_split()
				vim.api.nvim_feedkeys( vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
			end, { desc = "Send selection to ipython" })

			vim.keymap.set("v", "<leader>i", function()
				open_ipython_split()
				vim.api.nvim_feedkeys( vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
			end, { desc = "Send selection to ipython" })

		end,
	},
	{
		"Vigemus/iron.nvim",
		ft = "python",
		enabled = false,
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
