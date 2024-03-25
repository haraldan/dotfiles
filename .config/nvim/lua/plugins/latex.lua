return {
	"lervag/vimtex",
	init = function()
		-- Use init for configuration, don't use the more common "config".
		-- vim.g.vimtex_compiler_latexmk = { aux_dir = "build/" }
		vim.g.vimtex_view_general_viewer = "open_sumatrapdf.sh"
		vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
	end,
}
