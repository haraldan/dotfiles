-- vim.opt.mouse = ""

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- line numbers
-- opt.relativenumber = true -- show relative line numbers
vim.opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2    -- spaces for indent width
vim.opt.expandtab = true  -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- split on the right
vim.opt.splitright = true
-- don't wrap text
vim.opt.wrap = false

-- turn on textwidth, turn off automatic wrapping
vim.opt.textwidth = 150
vim.opt.colorcolumn = "+1"

-- sync clipboard with system
-- vim.opt.clipboard = "unnamedplus"

-- set formatoptions
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "o" })
    vim.opt.formatoptions:remove({ "t" })
  end,
})

-- ignore case when searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Normal mode shortcuts
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Reset highlights" })
vim.keymap.set("n", "<leader>pcd", ":lcd %:h<CR>", { desc = "Change cwd to current file" })
vim.keymap.set("n", "<leader>pw", ":pwd<CR>", { desc = "Check cwd" })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "[b", ":bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[c", ":cprev<CR>", { desc = "Previous quickfix entry" })
vim.keymap.set("n", "]c", ":cnext<CR>", { desc = "Next quickfix entry" })
vim.keymap.set("n", "<C-x>", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<C-z>", "<C-x>", { desc = "Decrement next number" })
vim.keymap.set("n", "<leader>=", "gg0vG=<C-o>", { desc = "Auto-indent file" })
vim.keymap.set("n", "<C-q>", "3<C-y>")
vim.keymap.set("n", "<C-e>", "3<C-e>")
vim.keymap.set("n", "<C-j>", ":m+1<CR>")
vim.keymap.set("n", "<C-k>", ":m-2<CR>")
vim.keymap.set({ "n", "v" }, "E", "$")
vim.keymap.set({ "n", "v" }, "B", "^")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<C-t>", "gt")
vim.keymap.set("n", "<C-w>\\", ":vs<CR>")
vim.keymap.set("n", "<C-w>-", ":sp<CR>")
vim.keymap.set("n", "ZZ", ":wqa<CR>")
vim.keymap.set("n", "ZQ", ":qa!<CR>")

-- Insert mode shortcuts
vim.keymap.set({ "i", "n" }, "<C-h>", "<Left>")
vim.keymap.set({ "i", "n" }, "<C-l>", "<Right>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>")

-- change update time for CursorHold events
vim.opt.updatetime = 2000

-- stop annoying TODO highlights
-- vim.api.nvim_set_hl(0, "Todo", { link = "Comment" })
vim.api.nvim_set_hl(0, "vhdlTodo", { link = "vhdlComment" })

-- close pop-up windows with ESC
vim.keymap.set("n", "<ESC>", function ()
  vim.cmd.fclose()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>',true,true,true),'n',false)
end)

-- persistent undo
-- vim.opt.undodir = '~/.config/nvim/.undo/'
-- vim.opt.undofile = true
