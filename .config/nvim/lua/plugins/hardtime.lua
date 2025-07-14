return {
	"m4xshen/hardtime.nvim",
	lazy = false,
	-- enabled = false,
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		disable_mouse = false,
		max_count = 5,
		restricted_keys = {
			["h"] = { "n", "x" },
			["j"] = { "n", "x" },
			["k"] = { "n", "x" },
			["l"] = { "n", "x" },
			["+"] = {},
			["gj"] = {},
			["gk"] = {},
			["<C-M>"] = {},
			["<C-N>"] = {},
			["<C-P>"] = {},
		},
		disabled_keys = {
			["<Up>"] = false,
			["<Down>"] = false,
			["<Left>"] = false,
			["<Right>"] = false,
		},
	},
}
