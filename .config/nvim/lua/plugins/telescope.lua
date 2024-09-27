return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
      defaults = {
        path_display = { "truncate " },
        file_ignore_patterns = { ".git/" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-\\>"] = actions.select_vertical,
            ["<C-x>"] = false,
          },
          n = {
            ["<C-s>"] = actions.select_horizontal,
            ["<C-x>"] = false,
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-\\>"] = actions.select_vertical,
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<C-x>"] = actions.delete_buffer,
            },
            n = {
              ["<C-x>"] = actions.delete_buffer,
            },
          },
        },
      },
    })

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("session-lens")
    require("telescope").load_extension("git_signs")

    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    vim.keymap.set("n", "<leader>fO", builtin.vim_options, { desc = "[F]ind Vim [O]ptions" })
    vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "[F]ind [J]umps" })
    vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[F]ind [M]arks" })
    vim.keymap.set("n", "<leader>fG", builtin.git_status, { desc = "[F]ind in [G]it status" })
    vim.keymap.set("n", "<leader>fH", ":Telescope git_signs<CR>", { desc = "[F]ind [H]unks" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fa", function()
      builtin.find_files({ no_ignore = true, hidden = true })
    end, { desc = "[F]ind [A]ll files, including hidden and ignored" })
    vim.keymap.set("n", "<leader>ft", builtin.builtin, { desc = "[F]ind [T]elescope commands" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
    vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "Repeat last search" })
    vim.keymap.set("n", "<leader>fR", builtin.registers, { desc = "[F]ind [R]egisters" })
    vim.keymap.set("n", "<leader>fS", builtin.spell_suggest, { desc = "[F]ind [S]pelling suggestions" })
    vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "[F]ind [Q]uickfix items" })
    vim.keymap.set(
      "n",
      "<leader>/",
      builtin.current_buffer_fuzzy_find,
      { desc = "[/] Fuzzily search in current buffer" }
    )

    vim.keymap.set("n", "<leader>fr", function ()
      builtin.oldfiles({promt_title = "Recent Files"})
    end, 
      { desc = "[F]ind [r]ecent" })
    vim.keymap.set("n", "<leader>b", function()
      builtin.buffers({ sort_mru = true })
    end, { desc = "List open [B]uffers" })

    vim.keymap.set("n", "<leader>fd", function()
      builtin.diagnostics({ bufnr = 0 })
    end, { desc = "[F]ind [D]iagnostics in current buffer" })

    vim.keymap.set("n", "<leader>fo", function()
      builtin.grep_string({
        prompt_title = "Fuzzy Search in Open Files",
        word_match = "-w",
        only_sort_text = true,
        grep_open_files = true,
        search = "",
      })
    end, { desc = "[F]ind in [O]pen Files" })

    vim.keymap.set("n", "<leader>fW", function()
      builtin.grep_string({
        prompt_title = "Fuzzy Search in Workspace",
        word_match = "-w",
        only_sort_text = true,
        search = "",
      })
    end, { desc = "[F]ind in [W]orkspace" })


    vim.keymap.set("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[F]ind [N]eovim files" })
  end,
}
