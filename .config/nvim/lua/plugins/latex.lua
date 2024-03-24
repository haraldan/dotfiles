return {
	"lervag/vimtex",
	init = function()
		-- Use init for configuration, don't use the more common "config".
		vim.g.vimtex_compiler_latexmk = { aux_dir = "build/" }
		vim.g.vimtex_view_general_viewer = "sumatraPDF"
		vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
	end,
}
