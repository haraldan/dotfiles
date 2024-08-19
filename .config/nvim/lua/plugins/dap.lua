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
			require("dapui").setup()
			local function dapui_open()
				vim.opt.splitright = false
				dapui.open()
				vim.opt.splitright = true
			end
			dap.listeners.before.attach.dapui_config = function()
				dapui_open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui_open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

      -- Breakpoint symbols
			vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#d91414" })
			vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "", numhl = "" })

      -- Mappings
			vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>dc", dap.clear_breakpoints, { desc = "DAP: Clear Breakpoints" })
			vim.keymap.set("n", "<Leader>dx", dap.terminate, { desc = "DAP: Terminate Session" })
			vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP: Run Last" })
			vim.keymap.set("n", "<Leader>dr", dap.restart, { desc = "DAP: Restart Session" })
			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)
			vim.keymap.set("n", "<F5>", function()
				if vim.fn.filereadable(".vscode/launch.json") then
					require("dap.ext.vscode").load_launchjs(".dap/launch.json", { cppdbg = { "c", "cpp" } })
				end
				require("dap").continue()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "DAP: Hover" })

			vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP UI: Toggle UI" })
			vim.keymap.set(
				{ "n", "v" },
				"<Leader>dw",
				dapui.elements.watches.add,
				{ desc = "DAP UI: Add to Watch Expressions" }
			)

			-- vim.keymap.set("n", "<Leader>dm", require('dap-python').test_method)
			-- vim.keymap.set("v", "<Leader>ds", require('dap-python').debug_selection)

			-- hover functionality, depending on the environment
			vim.keymap.set({"n", "v"}, "K", function()
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
			vim.keymap.set("n", "<M-K>", vim.lsp.buf.hover)

		end,
	},
}
