return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      pre_save_cmds = { "NvimTreeClose" },
			session_lens = {
				-- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
				buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},
		})
    vim.o.sessionoptions="buffers,curdir,help,tabpages,folds,winsize,winpos,terminal"
		vim.keymap.set("n", "<leader>fs", require("auto-session.session-lens").search_session, {
			noremap = true,
			desc = "[F]ind [S]essions",
		})
	end,
}
