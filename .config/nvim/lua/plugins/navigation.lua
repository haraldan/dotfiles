return {
	"echasnovski/mini.bracketed",
	version = false,
	config = function()
		require("mini.bracketed").setup({
			buffer = { suffix = "b", options = {} },
			comment = { suffix = "c", options = {} },
			indent = { suffix = "i", options = {change_type="diff"} },
			quickfix = { suffix = "q", options = {} },
			conflict = { suffix = "", options = {} },
			diagnostic = { suffix = "", options = {} },
			file = { suffix = "", options = {} },
			jump = { suffix = "", options = {} },
			location = { suffix = "", options = {} },
			oldfile = { suffix = "", options = {} },
			treesitter = { suffix = "", options = {} },
			undo = { suffix = "", options = {} },
			window = { suffix = "", options = {} },
			yank = { suffix = "", options = {} },
		})
	end,
}
