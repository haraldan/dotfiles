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
        command = "~/.local/share/nvim/mason/bin/OpenDebugAD7",
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
          stopAtEntry = true,
        },
        {
          name = "Attach to gdbserver :1234",
          type = "cppdbg",
          request = "launch",
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:1234",
          miDebuggerPath = "/usr/bin/gdb",
          cwd = "${workspaceFolder}",

          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
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

      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#d91414'})
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379'})
      vim.fn.sign_define('DapBreakpoint', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='DapStopped', linehl ='', numhl =''})

      vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
      vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
      vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
      vim.keymap.set('n', '<F6>', function() require('dap').continue() end)
      vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
      vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
      vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
      vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
      end)
      -- vim.keymap.set("n", "<Leader>dm", require('dap-python').test_method)
      -- vim.keymap.set("v", "<Leader>ds", require('dap-python').debug_selection)
    end,
  },
}
