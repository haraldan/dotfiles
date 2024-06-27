return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- disable netrw at the very start of your init.lua
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		-- optionally enable 24-bit colour
		vim.opt.termguicolors = true
		-- empty setup using defaults
		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set("n", "<C-e>", "3<C-e>", opts("scroll down"))
			-- vim.keymap.set("n", "<C-q>", "<C-q>", opts("scroll up"))
			-- vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
		end
		require("nvim-tree").setup({
			on_attach = my_on_attach,
			update_focused_file = {
				enable = true,
				-- update_root = true,
			},
			filters = {
				git_ignored = false,
			},
			respect_buf_cwd = true,
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
	end,
}
