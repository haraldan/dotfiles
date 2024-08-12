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
          name = "Launch file",
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
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#d91414" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "", numhl = "" })

      vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>dx", dap.terminate, { desc = "DAP: Terminate Session" })
      vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP: Run Last" })
      vim.keymap.set("n", "<Leader>dr", dap.restart, { desc = "DAP: Restart Session" })
      vim.keymap.set("n", "<F6>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "DAP: Hover" })

      vim.keymap.set("n", "<Leader>dc", dapui.close, { desc = "DAP UI: Close" })
      vim.keymap.set(
        { "n", "v" },
        "<Leader>dw",
        dapui.elements.watches.add,
        { desc = "DAP UI: Add to Watch Expressions" }
      )
      vim.keymap.set({ "n", "v" }, "<Leader>de", function()
        dapui.eval()
        dapui.eval()
      end, { desc = "DAP UI: Evaluate" })

      -- vim.keymap.set("n", "<Leader>dm", require('dap-python').test_method)
      -- vim.keymap.set("v", "<Leader>ds", require('dap-python').debug_selection)

      -- close floats with q or esc
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-float",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, "n", "<ESC>", "<cmd>close!<CR>", { noremap = true, silent = true })
        end,
      })

      -- hover functionality, depending on the environment
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        local session = require("dap").session()
        if not winid then
          if session ~= nil then
            require("dapui").eval()
            require("dapui").eval()
          else
            vim.lsp.buf.hover()
          end
        end
      end)
    end,
  },
}
