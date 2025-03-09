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
	end,

	config = function()
		local function get_tmux_pane_id()
			local pane_id
			if vim.bo.filetype == "python" then
				pane_id = vim.fn.system("~/.tmux/tmux_split_get_pane_id.sh -n ipython")
			elseif vim.bo.filetype == "matlab" then
				pane_id = vim.fn.system("~/.tmux/tmux_split_get_pane_id.sh -n matlab")
			end
			return pane_id:sub(1, -2)
		end

		local function update_tmux_pane_id()
			local pane_id = get_tmux_pane_id()
			local slime_config = '{"socket_name": "default", "target_pane": "' .. pane_id .. '"}'
			vim.cmd([[let g:slime_default_config =]] .. slime_config)
			vim.cmd([[let b:slime_config =]] .. slime_config)
		end

		local function open_tmux_split()
			if vim.bo.filetype == "python" then
				local venv = require("venv-selector").venv()
				vim.cmd(
					'silent !~/.tmux/tmux_split_open.sh -n ipython -h -l 40\\% -c "' .. venv .. '/bin/ipython --no-autoindent"')
			elseif vim.bo.filetype == "matlab" then
				vim.cmd(
					[[silent !~/.tmux/tmux_split_open.sh -n matlab -h -l 40\\% -c "matlab -nodesktop -nosplash 2> >(sed $'s,.*,\e[31m&\e[m,'>&2)"]]
				)
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

		local function matlab_get_filepath()
			local filepath = vim.fn.expand("%")
			filepath = string.sub(filepath, 1, -3)
			if string.sub(filepath, 1, 1) == "+" then
				filepath = filepath:gsub("+", "")
				filepath = filepath:gsub("/", ".")
			end
			return filepath
		end

		local function send_buffer()
			open_tmux_split()
			vim.cmd("w")
			if vim.bo.filetype == "python" then
				vim.cmd("SlimeSend1 %run " .. vim.fn.expand("%"))
			elseif vim.bo.filetype == "matlab" then
				vim.cmd("SlimeSend1 " .. matlab_get_filepath())
			end
		end

		vim.keymap.set("n", "<leader>ii", open_tmux_split, { desc = "Open REPL split", silent = true })
		vim.keymap.set("n", "<leader>iq", close_tmux_split, { desc = "Close REPL split", silent = true })

		vim.keymap.set("n", "<leader>ix", function()
			if vim.bo.filetype == "python" then
				vim.cmd("SlimeSend1 %reset -f")
			elseif vim.bo.filetype == "matlab" then
				vim.cmd("SlimeSend1 clear all")
			end
		end, { desc = "Reset REPL", silent = true })

		vim.keymap.set("n", "<leader>ir", function()
			close_tmux_split()
			open_tmux_split()
		end, { desc = "Restart REPL", silent = true })

		vim.keymap.set("n", "<leader>iz", function()
			local pane_id = get_tmux_pane_id()
			vim.cmd('silent !tmux send-keys -t "\\' .. pane_id .. '" C-c')
		end, { desc = "Send keyboard interrupt", silent = true })

		vim.keymap.set("n", "<leader>ic", function()
			if vim.bo.filetype == "python" then
				vim.cmd("SlimeSend1 clear")
			elseif vim.bo.filetype == "matlab" then
				vim.cmd("SlimeSend1 clc")
			end
		end, { desc = "Clear REPL", silent = true })

		vim.keymap.set("n", "<F8>", function()
			send_buffer()
		end, { desc = "Run buffer in REPL", silent = true })

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

		vim.keymap.set("n", "<leader>io", function()
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
			if vim.bo.filetype == "python" then
				if vim.fn.expand("<cword>") ~= "" then
					vim.cmd("SlimeSend1 type(" .. vim.fn.expand("<cword>") .. ")")
				end
			end
		end, { desc = "Get type for word under cursor", silent = true })

		vim.keymap.set("n", "<leader>ie", function()
			if vim.bo.filetype == "matlab" then
				vim.cmd("SlimeSend1 edit " .. matlab_get_filepath())
			end
		end, { desc = "Edit buffer in Matlab editor", silent = true })

		vim.keymap.set("n", "<leader>iv", function()
			if vim.bo.filetype == "python" then
				vim.cmd("SlimeSend1 %whos")
			elseif vim.bo.filetype == "matlab" then
				vim.cmd("SlimeSend1 workspace")
			end
		end, { desc = "List variables in REPL", silent = true })

		vim.keymap.set("n", "<leader>ih", function()
			if vim.bo.filetype == "python" then
				if vim.fn.expand("<cword>") ~= "" then
					vim.cmd("SlimeSend1 help(" .. vim.fn.expand("<cword>") .. ")")
				end
			elseif vim.bo.filetype == "matlab" then
				if vim.fn.expand("<cword>") ~= "" then
					vim.cmd('SlimeSend1 help("' .. vim.fn.expand("<cword>") .. '")')
				end
			end
		end, { desc = "Get help for current word", silent = true })

		vim.keymap.set("n", "]o", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeCellsNext", true, true, true), "m", true)
		end, { desc = "Next cell" })

		vim.keymap.set("n", "[o", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeCellsPrev", true, true, true), "m", true)
		end, { desc = "Previous cell" })

		vim.keymap.set("v", "<leader>ih", function()
			if vim.bo.filetype == "python" then
				vim.cmd("SlimeSend1 help(" .. Get_visual_selection_text()[1] .. ")")
			elseif vim.bo.filetype == "matlab" then
				vim.cmd('SlimeSend1 help("' .. Get_visual_selection_text()[1] .. '")')
			end
		end, { desc = "Get help for selection", silent = true })

		vim.keymap.set("v", "<F9>", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
		end, { desc = "Send selection to REPL" })

		vim.keymap.set("v", "<leader>io", function()
			open_tmux_split()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
		end, { desc = "Send selection to REPL" })
	end,
}
