return {
	{
		"echasnovski/mini.comment",
		version = false,
		opts = {
			mappings = {
				-- Toggle comment (like `gcip` - comment inner paragraph) for both
				-- Normal and Visual modes
				comment = "",
				-- Toggle comment on current line
				comment_line = "",
				-- Toggle comment on visual selection
				comment_visual = "",
				-- Define 'comment' textobject (like `dgc` - delete whole comment block)
				-- Works also in Visual mode if mapping differs from `comment_visual`
				textobject = "ic",
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				---Line-comment toggle keymap
				line = "<leader>cc",
				---Block-comment toggle keymap
				block = "<leader>c]",
			},
			-- -LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				-- -Line-comment keymap
				line = "<leader>cx",
				---Block-comment keymap
				block = "<leader>cb",
			},
			extra = {
				---Add comment on the line above
				above = "<leader>cO",
				---Add comment on the line below
				below = "<leader>co",
				---Add comment at the end of line
				eol = "<leader>ca",
			},
		},
	},
}
