return {
	{
		"radyz/telescope-gitsigns",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					if vim.api.nvim_buf_get_name(bufnr):match("%.ipynb$") then
						-- Do not attach for .ipynb file, since these are converted
						-- with jupytext.nvim
						return false
					end
				end,
			})

			local gitsigns = require("gitsigns")

			-- Navigation
			vim.keymap.set("n", "]h", function()
				gitsigns.nav_hunk("next")
				vim.cmd.normal("zz")
			end, { desc = "Gitsigns: Next hunk" })

			vim.keymap.set("n", "[h", function()
				gitsigns.nav_hunk("prev")
				vim.cmd.normal("zz")
			end, { desc = "Gitsigns: Previous hunk" })

			-- Actions
			vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Gitsigns: Stage hunk" })
			vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Gitsigns: Reset hunk" })
			vim.keymap.set("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Gitsigns: Stage hunk (visual mode)" })
			vim.keymap.set("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Gitsigns: Reset hunk (visual mode)" })
			vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Gitsigns: Stage buffer" })
			vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Gitsigns: Undo stage hunk" })
			vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Gitsigns: Reset buffer" })
			vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Gitsigns: Preview hunk" })
			vim.keymap.set("n", "<leader>gb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "Gitsigns: Line blame" })
			vim.keymap.set("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Gitsigns: Toggle current line blame" })
			vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "Gitsigns: Diff buffer against the index" })
			vim.keymap.set("n", "<leader>gD", function()
				gitsigns.diffthis("~")
			end, { desc = "Gitsigns: Diff buffer against last commit" })
			vim.keymap.set("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Gitsigns: Toggle deleted" })

			-- Text object
			vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns: Select text in hunk" })
		end,
	},
}
