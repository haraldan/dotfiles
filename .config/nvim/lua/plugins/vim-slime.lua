return {
	"jpalardy/vim-slime",
	dependencies = {
		"linux-cultist/venv-selector.nvim",
		"haraldan/vim-slime-cells",
	},
	ft = { "python", "matlab" },
	init = function()
		vim.g.slime_no_mappings = 1
		vim.g.slime_target = "tmux"
		vim.g.slime_dont_ask_default = 1
		vim.g.slime_bracketed_paste = 1
		vim.cmd([[let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}]])
		vim.g.slime_cell_delimiter = "##"
	end,

	config = function()
		local function update_tmux_pane_id()
			local pane_id
			if vim.bo.filetype == "python" then
				pane_id = vim.fn.system("~/.tmux/tmux_split_get_pane_id.sh -n ipython")
			elseif vim.bo.filetype == "matlab" then
				pane_id = vim.fn.system("~/.tmux/tmux_split_get_pane_id.sh -n matlab")
			end
			local slime_config = '{"socket_name": "default", "target_pane": "' .. pane_id:sub(1, -2) .. '"}'
			vim.cmd([[let g:slime_default_config =]] .. slime_config)
			vim.cmd([[let b:slime_config =]] .. slime_config)
		end

		local function open_tmux_split()
			print(vim.bo.filetype)
			if vim.bo.filetype == "python" then
				local venv = require("venv-selector").venv()
				vim.cmd("silent !~/.tmux/tmux_ipython_split.sh " .. venv .. "/bin/ipython --no-autoindent")
			elseif vim.bo.filetype == "matlab" then
				vim.cmd('silent !~/.tmux/tmux_split_open.sh -n matlab -h -c "matlab -nodesktop -nosplash"')
			end
				update_tmux_pane_id()
		end

		local function close_tmux_split()
			if vim.bo.filetype == "python" then
				vim.cmd("silent !~/.tmux/tmux_split_close.sh -n ipython")
			elseif vim.bo.filetype == "matlab" then
				vim.cmd("silent !~/.tmux/tmux_split_close.sh -n matlab")
			end
		end

		vim.keymap.set("n", "<leader>ii", open_tmux_split, { desc = "Open REPL split", silent = true })
		vim.keymap.set("n", "<leader>iq", close_tmux_split, { desc = "Close REPL split", silent = true })

		vim.keymap.set("n", "<leader>ix", function()
			vim.cmd("SlimeSend1 %reset -f")
		end, { desc = "Reset REPL", silent = true })

		vim.keymap.set("n", "<leader>ir", function()
			close_tmux_split()
			open_tmux_split()
		end, { desc = "Restart REPL", silent = true })

		vim.keymap.set("n", "<leader>ic", function()
			vim.cmd("SlimeSend1 clear")
		end, { desc = "Clear REPL", silent = true })

		vim.keymap.set("n", "<F8>", function()
			open_tmux_split()
			vim.cmd("%SlimeSend")
		end, { desc = "Send buffer to REPL", silent = true })

		vim.keymap.set("n", "<leader>ib", function()
			open_tmux_split()
			vim.cmd("%SlimeSend")
		end, { desc = "Send buffer to REPL", silent = true })

		vim.keymap.set("n", "<leader>il", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeLineSend", true, true, true), "m", true)
		end, { desc = "Send line to REPL" })

		vim.keymap.set("n", "<leader>ip", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes("<Plug>SlimeParagraphSend", true, true, true),
				"m",
				true
			)
		end, { desc = "Send paragraph to REPL" })

		vim.keymap.set("n", "<leader>ie", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeSendCell", true, true, true), "m", true)
		end, { desc = "Send cell to REPL" })

		vim.keymap.set("n", "<F9>", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeSendCell", true, true, true), "m", true)
		end, { desc = "Send cell to REPL" })

		vim.keymap.set("n", "<leader>in", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes("<Plug>SlimeCellsSendAndGoToNext", true, true, true),
				"m",
				true
			)
		end, { desc = "Send cell to REPL and go to next" })

		vim.keymap.set("n", "<leader>iw", function()
			if vim.fn.expand("<cword>") ~= "" then
				vim.cmd("SlimeSend1 " .. vim.fn.expand("<cword>"))
			end
		end, { desc = "Send word under cursor to REPL", silent = true })

		vim.keymap.set("n", "<leader>it", function()
			if vim.fn.expand("<cword>") ~= "" then
				vim.cmd("SlimeSend1 type(" .. vim.fn.expand("<cword>") .. ")")
			end
		end, { desc = "Get type for word under cursor", silent = true })

		vim.keymap.set("n", "<leader>iv", function()
			vim.cmd("SlimeSend1 %whos")
		end, { desc = "List variables in REPL", silent = true })

		vim.keymap.set("n", "]c", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeCellsNext", true, true, true), "m", true)
		end, { desc = "Next cell" })

		vim.keymap.set("n", "[c", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeCellsPrev", true, true, true), "m", true)
		end, { desc = "Previous cell" })

		vim.keymap.set("v", "<F7>", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
		end, { desc = "Send selection to REPL" })

		vim.keymap.set("v", "<leader>i", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
		end, { desc = "Send selection to REPL" })
	end,
}
