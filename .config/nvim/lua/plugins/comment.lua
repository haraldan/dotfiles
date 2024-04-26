return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
    opleader = {
        ---Line-comment keymap
        line = 'gcc',
        ---Block-comment keymap
        block = 'gbc',
    },
	},
}
