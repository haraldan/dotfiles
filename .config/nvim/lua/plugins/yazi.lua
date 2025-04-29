return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    -- check the installation instructions at
    -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim"
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>e",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    -- {
    --   -- Open in the current working directory
    --   "<leader>e",
    --   "<cmd>Yazi cwd<cr>",
    --   desc = "Open Yazi in nvim's working directory",
    -- },
    {
      "<leader>-",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true,
    keymaps = {
      show_help = "<F2>",
      open_file_in_vertical_split = "<c-\\>",
      open_file_in_horizontal_split = "<c-s>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<C-o>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<M-d>",
    },
    highlight_hovered_buffers_in_same_directory = false,
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
