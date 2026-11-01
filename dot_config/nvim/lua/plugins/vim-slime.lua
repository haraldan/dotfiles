return {
	"jpalardy/vim-slime",
	dependencies = {
		"linux-cultist/venv-selector.nvim",
		"haraldan/vim-slime-cells",
		"haraldan/nvim-slime-splits",
	},
	ft = { "python", "matlab" },
	init = function()
		vim.g.slime_no_mappings = 1
		vim.g.slime_dont_ask_default = 1
		vim.g.slime_bracketed_paste = 1
	end,

	config = function()
		local splits = require("slime_splits")
		local split_names = { python = "ipython", matlab = "matlab" }

		local function get_visual_selection_text()
			local _, srow, scol = table.unpack(vim.fn.getpos("v"))
			local _, erow, ecol = table.unpack(vim.fn.getpos("."))

			if vim.fn.mode() == "V" then
				if srow > erow then
					return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
				else
					return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
				end
			end

			if vim.fn.mode() == "v" then
				if srow < erow or (srow == erow and scol <= ecol) then
					return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
				else
					return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
				end
			end

			if vim.fn.mode() == "\22" then
				local lines = {}
				if srow > erow then
					srow, erow = erow, srow
				end
				if scol > ecol then
					scol, ecol = ecol, scol
				end
				for i = srow, erow do
					table.insert(
						lines,
						vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
					)
				end
				return lines
			end
		end

		local function open_split()
			if vim.bo.filetype == "python" then
				local venv = require("venv-selector").venv()
				return splits.open("ipython", { command = venv .. "/bin/ipython --no-autoindent", size = 0.4 })
			elseif vim.bo.filetype == "matlab" then
				return splits.open("matlab", {
					command = [[matlab -nodesktop -nosplash 2> >(sed $'s,.*,\e[31m&\e[m,'>&2)]],
					size = 0.4,
				})
			end
		end

		-- Every send goes through open_split, so slime only ever targets the REPL split
		local function send(text)
			if open_split() then
				vim.cmd("SlimeSend1 " .. text)
			end
		end

		local function send_plug(plug)
			if open_split() then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(plug, true, true, true), "m", true)
			end
		end

		local function close_split()
			local name = split_names[vim.bo.filetype]
			if name then
				splits.close(name)
			end
		end

		local function matlab_get_filepath()
			local filepath = vim.fn.expand("%:.")
			filepath = string.sub(filepath, 1, -3)
			if string.sub(filepath, 1, 1) == "+" then
				filepath = filepath:gsub("+", "")
				filepath = filepath:gsub("/", ".")
			end
			return filepath
		end

		local function send_buffer()
			vim.cmd("w")
			if vim.bo.filetype == "python" then
				send("%run " .. vim.fn.expand("%"))
			elseif vim.bo.filetype == "matlab" then
				send(matlab_get_filepath())
			end
		end

		vim.keymap.set("n", "<leader>ii", open_split, { desc = "Open REPL split", silent = true })
		vim.keymap.set("n", "<leader>iq", close_split, { desc = "Close REPL split", silent = true })

		vim.keymap.set("n", "<leader>ix", function()
			if vim.bo.filetype == "python" then
				send("%reset -f")
			elseif vim.bo.filetype == "matlab" then
				send("clear all")
			end
		end, { desc = "Reset REPL", silent = true })

		vim.keymap.set("n", "<leader>ir", function()
			close_split()
			open_split()
		end, { desc = "Restart REPL", silent = true })

		vim.keymap.set("n", "<leader>iz", function()
			local name = split_names[vim.bo.filetype]
			if name then
				splits.interrupt(name)
			end
		end, { desc = "Send keyboard interrupt", silent = true })

		vim.keymap.set("n", "<leader>ic", function()
			if vim.bo.filetype == "python" then
				send("clear")
			elseif vim.bo.filetype == "matlab" then
				send("clc")
			end
		end, { desc = "Clear REPL", silent = true })

		vim.keymap.set("n", "<F8>", function()
			send_buffer()
		end, { desc = "Run buffer in REPL", silent = true })

		vim.keymap.set("n", "<leader>ib", function()
			if open_split() then
				vim.cmd("%SlimeSend")
			end
		end, { desc = "Send buffer to REPL", silent = true })

		vim.keymap.set("n", "<leader>il", function()
			send_plug("<Plug>SlimeLineSend")
		end, { desc = "Send line to REPL" })

		vim.keymap.set("n", "<leader>ip", function()
			send_plug("<Plug>SlimeParagraphSend")
		end, { desc = "Send paragraph to REPL" })

		vim.keymap.set("n", "<leader>io", function()
			send_plug("<Plug>SlimeSendCell")
		end, { desc = "Send cell to REPL" })

		vim.keymap.set("n", "<F9>", function()
			send_plug("<Plug>SlimeSendCell")
		end, { desc = "Send cell to REPL" })

		vim.keymap.set("n", "<leader>in", function()
			send_plug("<Plug>SlimeCellsSendAndGoToNext")
		end, { desc = "Send cell to REPL and go to next" })

		vim.keymap.set("n", "<leader>iw", function()
			if vim.fn.expand("<cword>") ~= "" then
				send(vim.fn.expand("<cword>"))
			end
		end, { desc = "Send word under cursor to REPL", silent = true })

		vim.keymap.set("n", "<leader>it", function()
			if vim.bo.filetype == "python" then
				if vim.fn.expand("<cword>") ~= "" then
					send("type(" .. vim.fn.expand("<cword>") .. ")")
				end
			end
		end, { desc = "Get type for word under cursor", silent = true })

		vim.keymap.set("n", "<leader>ie", function()
			if vim.bo.filetype == "matlab" then
				send("edit " .. matlab_get_filepath())
			end
		end, { desc = "Edit buffer in Matlab editor", silent = true })

		vim.keymap.set("n", "<leader>iv", function()
			if vim.bo.filetype == "python" then
				send("%whos")
			elseif vim.bo.filetype == "matlab" then
				send("whos")
			end
		end, { desc = "List variables in REPL", silent = true })

		vim.keymap.set("n", "<leader>ih", function()
			if vim.bo.filetype == "python" then
				if vim.fn.expand("<cword>") ~= "" then
					send("help(" .. vim.fn.expand("<cword>") .. ")")
				end
			elseif vim.bo.filetype == "matlab" then
				if vim.fn.expand("<cword>") ~= "" then
					send('help("' .. vim.fn.expand("<cword>") .. '")')
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
				send("help(" .. get_visual_selection_text()[1] .. ")")
			elseif vim.bo.filetype == "matlab" then
				send('help("' .. get_visual_selection_text()[1] .. '")')
			end
		end, { desc = "Get help for selection", silent = true })

		vim.keymap.set("v", "<F9>", function()
			send_plug("<Plug>SlimeRegionSend")
		end, { desc = "Send selection to REPL" })

		vim.keymap.set("v", "<leader>io", function()
			send_plug("<Plug>SlimeRegionSend")
		end, { desc = "Send selection to REPL" })
	end,
}
