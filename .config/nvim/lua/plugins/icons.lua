return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").setup({
			override_by_extension = {
				["m"] = {
					icon = "󱕍",
					color = "#e16e11",
					name = "Matlab",
				},
			},
		})
	end,
}
