return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-nvim-dap").setup({
				automatic_installation = true,
			})
		end,
	},
	{
		"ofirgall/goto-breakpoints.nvim",
		config = function()
			local map = vim.keymap.set
			map("n", "gb", require("goto-breakpoints").next, { desc = "Go to next breakpoint" })
			map("n", "gB", require("goto-breakpoints").prev, { desc = "Go to previous breakpoint" })
			map("n", "gs", require("goto-breakpoints").stopped, { desc = "Go to stopped position (debugger)" })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			-- Set up cursor behaviour
			dap.defaults.fallback.switchbuf = "usevisible,usetab,uselast"

			dap.defaults.fallback.external_terminal = {
				command = vim.fn.expand("~/.tmux/tmux_dap_split.sh"),
				-- command = "tmux",
				-- args = { "split-window", "-d", "-l", "20%" },
			}

			-- Python setup
			require("dap-python").setup("python")

			-- C/C++ setup
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.expand("~/.local/share/nvim/mason/bin/OpenDebugAD7"),
			}
			dap.configurations.cpp = {
				{
					name = "Launch file (gdb)",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					externalConsole = true,
					setupCommands = {
						{
							text = "-enable-pretty-printing",
							description = "enable pretty printing",
							ignoreFailures = false,
						},
					},
				},
			}
			dap.configurations.c = dap.configurations.cpp

			-- DapUI setup
			require("dapui").setup({
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.6,
							},
							{
								id = "watches",
								size = 0.2,
							},
							{
								id = "breakpoints",
								size = 0.2,
							},
						},
						position = "left",
						size = 40,
					},
					-- {
					-- 	elements = {
					-- 		{
					-- 			id = "console",
					-- 			size = 1,
					-- 		},
					-- 	},
					-- 	position = "bottom",
					-- 	size = 10,
					-- },
				},
			})
			local function dapui_open()
				vim.opt.splitright = false
				dapui.open()
				vim.opt.splitright = true
			end
			local function dapui_toggle()
				vim.opt.splitright = false
				dapui.toggle()
				vim.opt.splitright = true
			end
			-- Open Dap UI on DAP session start
			-- dap.listeners.before.attach.dapui_config = function()
			-- 	dapui_open()
			-- end
			-- dap.listeners.before.launch.dapui_config = function()
			-- 	dapui_open()
			-- end

			-- Close Dap UI on DAP session termination
			-- dap.listeners.before.event_terminated.dapui_config = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited.dapui_config = function()
			-- 	dapui.close()
			-- end

			-- Update floating window after debugger advanced
			local function UpdateHover()
				for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
					if vim.api.nvim_win_get_config(winid).relative ~= "" then
						vim.cmd.fclose()
						require("dapui").eval()
					end
				end
			end
			dap.listeners.after["event_stopped"]["xxx"] = function()
				UpdateHover()
			end

			-- Breakpoint symbols
			vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#d91414" })
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { ctermbg = 0, fg = "#2749f2" })
			vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "", numhl = "" })

			-- Mappings
			vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>dx", dap.clear_breakpoints, { desc = "DAP: Clear Breakpoints" })
			vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP: Run Last" })
			vim.keymap.set("n", "<Leader>dr", dap.restart, { desc = "DAP: Restart Session" })
			vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "DAP: Terminate Session" })
			vim.keymap.set("n", "<Leader>dg", function()
				dap.repl.toggle({ height = 10 })
			end, { desc = "DAP: Toggle Repl window" })
			vim.keymap.set("n", "<Leader>ds", function()
				vim.cmd("silent !~/.tmux/tmux_dap_split.sh")
			end, { desc = "DAP: Open Console" })
			vim.keymap.set("n", "<Leader>dq", function()
				dap.terminate()
				dapui.close()
				vim.cmd("silent !~/.tmux/tmux_dap_close.sh")
			end, { desc = "DAP: Quit Session" })
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "DAP: Hover" })
			vim.keymap.set("n", "<Leader>dc", function()
				vim.ui.input({ prompt = "Enter breakpoint condition:" }, function(input)
					if input ~= "" and input ~= nil then
						dap.set_breakpoint(input)
					else
						vim.notify("Breakpoint condition empty", vim.log.levels.WARN)
					end
				end)
			end, { desc = "DAP: Toggle Conditional Breakpoint" })

			vim.keymap.set("n", "<Leader>dn", function()
				vim.ui.input({ prompt = "Enter breakpoint hit number:" }, function(input)
					if input ~= "" and input ~= nil then
						dap.set_breakpoint("", input)
					else
						vim.notify("Breakpoint hit number empty", vim.log.levels.WARN)
					end
				end)
			end, { desc = "DAP: Toggle Hit Number Breakpoint" })

			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)
			vim.keymap.set("n", "<F5>", function()
				if vim.fn.filereadable(".dap/launch.json") then
					require("dap.ext.vscode").load_launchjs(".dap/launch.json", { cppdbg = { "c", "cpp" } })
				end
				require("dap").continue()
			end)

			vim.keymap.set("n", "<Leader>du", dapui_toggle, { desc = "DAP UI: Toggle UI" })
			vim.keymap.set(
				{ "n", "v" },
				"<Leader>dw",
				dapui.elements.watches.add,
				{ desc = "DAP UI: Add to Watch Expressions" }
			)

			-- vim.keymap.set("n", "<Leader>dm", require('dap-python').test_method)
			-- vim.keymap.set("v", "<Leader>ds", require('dap-python').debug_selection)

			-- hover functionality, depending on the environment
			vim.keymap.set({ "n", "v" }, "K", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				local session = require("dap").session()
				if not winid then
					if session ~= nil then
						require("dapui").eval()
					else
						vim.lsp.buf.hover()
					end
				end
			end)
			-- Additional mapping for LSP hover
			vim.keymap.set("n", "<M-K>", vim.lsp.buf.hover)
		end,
	},
}
