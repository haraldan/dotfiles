return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			-- Auto-install parsers and enable treesitter for all filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = args.match
					local lang = vim.treesitter.language.get_lang(ft) or ft

					if vim.tbl_contains(ts.get_installed(), lang) then
						vim.treesitter.start()
						if lang ~= "c" then
							vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						end
					elseif vim.tbl_contains(ts.get_available(), lang) then
						ts.install({ lang })
					end
				end,
			})
		end,
	},
}
