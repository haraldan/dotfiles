return {
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					sh = { "shfmt" },
				},
			})
			require("conform").formatters.shfmt = {
				prepend_args = { "-ci" },
			}
			vim.keymap.set("n", "<leader>lf", function()
				require("conform").format({ lsp_format = "fallback" })
			end, { desc = "Auto-format using Conform" })
		end,
	},
	{
		"zapling/mason-conform.nvim",
		config = true,
	},
}
