return {
	"levouh/tint.nvim",
	config = function ()
    require("tint").setup()
    vim.keymap.set("n", "<Leader>tt", require("tint").toggle, { desc = "Toggle Window Tint" })
	end
}
