return {
	"rshkarin/mason-nvim-lint",
	dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
	config = function()
		require("lint").linters_by_ft = {}
		require("mason-nvim-lint").setup({
			ensure_installed = { "shellcheck" },
		})
	end,
}
