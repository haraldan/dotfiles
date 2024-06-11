return {
  "haraldan/nvim-matlab",
  config = function ()
    vim.g.matlab_auto_mappings = 0
    vim.g.matlab_server_launcher = 'tmux'
    vim.g.matlab_server_split = 'left_30'

    vim.keymap.set("n", "<F5>", ":MatlabCliRunFile<CR>", { desc = "Matlab: Run File" })
  end
}
