-- Leader key
vim.g.mapleader = " "

-- line numbers
-- opt.relativenumber = true -- show relative line numbers
vim.opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2 -- spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- don't wrap text
vim.wo.wrap = false

-- turn on textwidth, turn off automatic folding
vim.opt.textwidth = 150
vim.opt.colorcolumn = "+1"
vim.opt.formatoptions:remove("t")

-- ignore case when searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Normal mode shortcuts
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Reset highlights" })
vim.keymap.set("n", "<leader>cd", ":lcd %:h<CR>", { desc = "Change cwd to current file" })
vim.keymap.set("n", "<leader>pw", ":pwd<CR>", { desc = "Check cwd" })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<C-p>", ":bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-n>", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-x>", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<C-z>", "<C-x>", { desc = "Decrement next number" })
vim.keymap.set("n", "<leader>=", "gg0vG=<C-o>", { desc = "Auto-indent file" })
vim.keymap.set("n", "<C-q>", "3<C-y>")
vim.keymap.set("n", "<C-e>", "3<C-e>")
vim.keymap.set("n", "<M-j>", ":m+1<CR>")
vim.keymap.set("n", "<M-k>", ":m-2<CR>")

-- Insert mode shortcuts
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>")

-- change update time for CursorHold events
vim.opt.updatetime = 2000

-- stop annoying TODO highlights
-- vim.api.nvim_set_hl(0, "Todo", { link = "Comment" })
vim.api.nvim_set_hl(0, "vhdlTodo", { link = "vhdlComment" })

-- auto-save and restore buffer views
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = "*.*",
	callback = function()
		vim.cmd([[mkview]])
	end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = "*.*",
	callback = function()
		vim.cmd([[silent! loadview]])
	end,
})

-- close pop-up windows with ESC
local hover_close = function(base_win_id)
	local windows = vim.api.nvim_tabpage_list_wins(0)
	for _, win_id in ipairs(windows) do
		if win_id ~= base_win_id then
			local win_cfg = vim.api.nvim_win_get_config(win_id)
			if win_cfg.relative == "win" and win_cfg.win == base_win_id then
				vim.api.nvim_win_close(win_id, {})
				break
			end
		end
	end
end

vim.keymap.set("n", "<ESC>", function()
	hover_close(vim.api.nvim_get_current_win())
end)
