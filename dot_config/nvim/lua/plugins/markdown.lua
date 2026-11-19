return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	-- Run install.sh as a lazy-tracked shell build so failures are reported;
	-- mkdp#util#install() runs it async in a terminal and lazy can't see it fail.
	build = "cd app && ./install.sh",
	config = function()
		vim.g.mkdp_auto_close = 0
		vim.g.mkdp_port = "8855"
		vim.g.mkdp_echo_preview_url = 1
		if vim.env.SSH_CONNECTION then
			vim.cmd([[
			function! MkdpSkipBrowser(url) abort
			endfunction
			]])
			vim.g.mkdp_browserfunc = "MkdpSkipBrowser"
		elseif vim.fn.has("wsl") == 1 then
			-- WSL: cmd.exe isn't on PATH (appendWindowsPath=false), so call it by full path.
			vim.cmd([[
			function! MkdpOpenWindows(url)
				call jobstart(['/mnt/c/Windows/System32/cmd.exe', '/c', 'start', '""', a:url], {'cwd': '/mnt/c'})
			endfunction
			]])
			vim.g.mkdp_browserfunc = "MkdpOpenWindows"
		end
	end,
}
