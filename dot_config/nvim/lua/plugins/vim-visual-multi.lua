return {
	"mg979/vim-visual-multi",
	branch = "master",
	init = function()
		vim.g.VM_maps = {
			["Find Under"] = "<leader>vf",
      ["Add Cursor Down"] = "<C-Down>" ,
      ["Add Cursor Up"]   = "<C-Up>" ,
		}
		vim.g.VM_theme = "ocean"
		vim.g.VM_add_cursor_at_pos_no_mappings = 1
		vim.g.VM_default_mappings = 0
    vim.keymap.set("n", "<leader>vc", "<Plug>(VM-Add-Cursor-At-Pos)", { desc = "Add cursor" })
    vim.keymap.set("v", "<leader>vc", "<Plug>(VM-Visual-Cursors)", { desc = "Add cursors" })
    vim.keymap.set("n", "<leader>v", "<Plug>(VM-Toggle-Mappings)", { desc = "Toggle VM mappings" })
    vim.keymap.set("n", "<leader>va", "<Plug>(VM-Select-All)", { desc = "VM Select all" })
    vim.keymap.set("n", "<leader>v/", "<Plug>(VM-Start-Regex-Search)", { desc = "VM Regex Search" })
	end,
}
