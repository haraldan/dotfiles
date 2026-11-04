return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	-- Run install.sh as a lazy-tracked shell build so failures are reported;
	-- mkdp#util#install() runs it async in a terminal and lazy can't see it fail.
	build = "cd app && ./install.sh",
	config = function()
		vim.g.mkdp_auto_close = 0
		-- WSL: cmd.exe isn't on PATH (appendWindowsPath=false), so call it by full path.
		if vim.fn.has("wsl") == 1 then
			vim.cmd([[
			function! MkdpOpenWindows(url)
				call jobstart(['/mnt/c/Windows/System32/cmd.exe', '/c', 'start', '""', a:url], {'cwd': '/mnt/c'})
			endfunction
			]])
			vim.g.mkdp_browserfunc = "MkdpOpenWindows"
		end
	end,
}
