return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
		},
		sections = {
			lualine_c = { require("auto-session.lib").current_session_name, "filename" },
			lualine_x = { "filetype", "%{&fo}" },
		},
	},
}
