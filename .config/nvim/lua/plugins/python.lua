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
      "haraldan/vim-slime-cells",
    },
    ft = "python",
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
      vim.keymap.set("n", "<leader>iq", close_ipython_split, { desc = "Close Ipython REPL", silent = true })

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

      vim.keymap.set("n", "<F8>", function()
        open_ipython_split()
        vim.cmd("%SlimeSend")
      end, { desc = "Send buffer to ipython", silent = true })

      vim.keymap.set("n", "<leader>ib", function()
        open_ipython_split()
        vim.cmd("%SlimeSend")
      end, { desc = "Send buffer to ipython", silent = true })

      vim.keymap.set("n", "<leader>il", function()
        open_ipython_split()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeLineSend", true, true, true), "m", true)
      end, { desc = "Send line to ipython" })

      vim.keymap.set("n", "<leader>ip", function()
        open_ipython_split()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeParagraphSend", true, true, true), "m", true)
      end, { desc = "Send paragraph to ipython" })

      vim.keymap.set("n", "<leader>ie", function()
        open_ipython_split()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeSendCell", true, true, true), "m", true)
      end, { desc = "Send cell to ipython" })

      vim.keymap.set("n", "<F9>", function()
        open_ipython_split()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeSendCell", true, true, true), "m", true)
      end, { desc = "Send cell to ipython" })

      vim.keymap.set("n", "<leader>in", function()
        open_ipython_split()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeCellsSendAndGoToNext", true, true, true), "m", true)
      end, { desc = "Send cell to ipython and go to next" })

      vim.keymap.set("n", "<leader>iw", function()
        if vim.fn.expand("<cword>") ~= "" then
          vim.cmd("SlimeSend1 " .. vim.fn.expand("<cword>"))
        end
      end, { desc = "Send word under cursor to ipython", silent = true })

      vim.keymap.set("n", "<leader>it", function()
        if vim.fn.expand("<cword>") ~= "" then
          vim.cmd("SlimeSend1 type(" .. vim.fn.expand("<cword>") .. ")")
        end
      end, { desc = "Get type for word under cursor", silent = true })

      vim.keymap.set("n", "<leader>iv", function()
        vim.cmd("SlimeSend1 %whos")
      end, { desc = "List variables in ipython", silent = true })

      vim.keymap.set("n", "]c", function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeCellsNext", true, true, true), "m", true)
      end, { desc = "Next cell" })

      vim.keymap.set("n", "[c", function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeCellsPrev", true, true, true), "m", true)
      end, { desc = "Previous cell" })

      vim.keymap.set("v", "<F7>", function()
        open_ipython_split()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
      end, { desc = "Send selection to ipython" })

      vim.keymap.set("v", "<leader>i", function()
        open_ipython_split()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true), "m", true)
      end, { desc = "Send selection to ipython" })

    end,
  },
  }
