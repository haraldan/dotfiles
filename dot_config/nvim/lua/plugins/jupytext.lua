return {
	"goerz/jupytext.nvim",
	version = "0.2.0",
	opts = {
		jupytext = vim.fn.expand("~/.virtualenvs/bat/bin/jupytext"),
		format = "py",
		update = true,
		sync_patterns = { "*.md", "*.py", "*.jl", "*.R", "*.Rmd", "*.qmd" },
		autosync = true,
		handle_url_schemes = true,
	},
}
