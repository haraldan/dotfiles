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
			map("n", "]x", require("goto-breakpoints").next, { desc = "Go to next breakpoint" })
			map("n", "[x", require("goto-breakpoints").prev, { desc = "Go to previous breakpoint" })
			map("n", "gs", require("goto-breakpoints").stopped, { desc = "Go to stopped position (debugger)" })
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"jedrzejboczar/nvim-dap-cortex-debug",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			-- Set up cursor behaviour
			dap.defaults.fallback.switchbuf = "usevisible,usetab,uselast"

			dap.defaults.fallback.external_terminal = {
				command = vim.fn.expand("~/.tmux/tmux_dap_split.sh"),
			}

			-- Python setup
      local python_path = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
			require("dap-python").setup(python_path, {
				include_configs = false,
			})

			dap.configurations.python = {
        {
				name = "file",
				type = "python",
				request = "launch",
				program = "${file}",
				console = "externalTerminal",
      }
			}

			-- Cpptools setup
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.expand("~/.local/share/nvim/mason/bin/OpenDebugAD7"),
			}
			dap.configurations.cpp = {
				{
					name = "Launch file with gdb",
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
			-- dap.configurations.c = dap.configurations.cpp

			-- Cortex-debug setup
			require("dap-cortex-debug").setup({
				debug = false, -- log debug messages
				-- path to cortex-debug extension, supports vim.fn.glob
				-- by default tries to guess: mason.nvim or VSCode extensions
				extension_path = nil,
				lib_extension = nil, -- shared libraries extension, tries auto-detecting, e.g. 'so' on unix
				node_path = "node", -- path to node.js executable
				dapui_rtt = false, -- register nvim-dap-ui RTT element
				-- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
				dap_vscode_filetypes = { "c" },
			})

			dap.configurations.c = {
				{
					name = "JLink debug",
					type = "cortex-debug",
					servertype = "jlink",
					serverpath = "JLinkGDBServerCLExe",
					request = "launch",
					interface = "swd",
					toolchainPath = "/opt/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin/",
					gdbPath = "arm-none-eabi-gdb",
					device = "MIMXRT685S_M33?BankAddr=0x8000000&Loader=Port_A&BankAddr=0x18000000&Loader=Port_B",
					showDevDebugOutput = "raw",
					cwd = "${workspaceFolder}",
					executable = "${workspaceFolder}/mt/build/arm-none-eabi/debug/sek",
					postLaunchCommands = { "source utils/gdbsettings.gdbinit", "source utils/sekconfigure.gdbinit" },
					rtos = "FreeRTOS",
					jlinkscript = "utils/disable-flash-cache.JLinkScript",
				},
			}

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
				},
				element_mappings = {
					stacks = { open = "<CR>" },
					breakpoints = { open = "<CR>" },
				},
			})
			-- Open Dap UI on DAP session start
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end

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

			-- Enable wrap in DAP Watches element
			vim.api.nvim_create_autocmd("BufWinEnter", {
				desc = "Set options on DAP windows",
				group = vim.api.nvim_create_augroup("set_dap_win_options", { clear = true }),
				pattern = { "\\[dap-repl\\]", "DAP Watches" },
				callback = function(args)
					local win = vim.fn.bufwinid(args.buf)
					vim.schedule(function()
						if not vim.api.nvim_win_is_valid(win) then
							return
						end
						vim.api.nvim_set_option_value("wrap", true, { win = win })
					end)
				end,
			})

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
				dapui.float_element("stacks", { enter = true })
			end, { desc = "DAP: Open Stacks float" })
			vim.keymap.set("n", "<Leader>dq", function()
				dap.terminate()
				dapui.close()
				vim.cmd("silent !~/.tmux/tmux_split_close.sh -n dap")
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
				if vim.fn.filereadable(".dap/launch.json") == 1 then
					print(vim.fn.getcwd())
					print(".dap/launch.json found")
					dap.configurations.c = {}
					dap.configurations.cpp = {}
					require("dap.ext.vscode").load_launchjs(".dap/launch.json", { cppdbg = { "c", "cpp" } })
				end
				require("dap").continue()
			end)

			vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP UI: Toggle UI" })
			vim.keymap.set(
				{ "n", "v" },
				"<Leader>dw",
				dapui.elements.watches.add,
				{ desc = "DAP UI: Add to Watch Expressions" }
			)

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
