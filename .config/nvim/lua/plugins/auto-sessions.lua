return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      silent_restore = false,
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      log_level = "error",
      pre_save_cmds = { "NvimTreeClose" },
      lazy_support = true,
			session_lens = {
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
