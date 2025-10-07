return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			continue_restore_on_error = false,
			lazy_support = true,
			log_level = "error",
			session_lens = {
				buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
				load_on_setup = true,
				previewer = false,
				theme_conf = { border = true },
			},
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		})
		vim.o.sessionoptions = "buffers,curdir,help,tabpages,folds,winsize,winpos,terminal,localoptions"
		vim.keymap.set("n", "<leader>fs", require("auto-session.session-lens").search_session, {
			noremap = true,
			desc = "[F]ind [S]essions",
		})
	end,
}
