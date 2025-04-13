return {
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			-- Use init for configuration, don't use the more common "config".
			vim.g.vimtex_compiler_latexmk = { aux_dir = "build/" }
			vim.g.vimtex_quickfix_open_on_warning = "0"
			vim.g.vimtex_view_method = "sioyek"
			vim.g.vimtex_view_sioyek_exe = "sioyek"
			vim.g.vimtex_callback_progpath = "wsl nvim"
		end,
	},
	{
		"micangl/cmp-vimtex",
	},
}
