return {
	"mg979/vim-visual-multi",
	branch = "master",
  -- enabled = false,
	init = function()
    vim.g.VM_leader = '<leader>m'
	end,
	config = function()
    vim.g.VM_theme = 'ocean'
    vim.g.VM_add_cursor_at_pos_no_mappings = 1
	end,
}
