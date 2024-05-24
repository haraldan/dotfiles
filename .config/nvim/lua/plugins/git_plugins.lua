return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Gitsigns: " .. desc })
					end

					-- Navigation
					map("n", "gh", function()
						gitsigns.nav_hunk("next")
            vim.cmd.normal("zz")
					end, "Next hunk")

					map("n", "gH", function()
							gitsigns.nav_hunk("prev")
            vim.cmd.normal("zz")
					end, "Previous hunk")

					-- Actions
					map("n", "<leader>gs", gitsigns.stage_hunk, "Stage hunk")
					map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")
					map("v", "<leader>gs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Stage hunk (visual mode)")
					map("v", "<leader>gr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Reset hunk (visual mode)")
					map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
					map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo stage hunk")
					map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")
					map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")
					map("n", "<leader>gb", function()
						gitsigns.blame_line({ full = true })
					end, "Line blame")
					map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle current line blame")
					map("n", "<leader>gd", gitsigns.diffthis, "Diff buffer against the index")
					map("n", "<leader>gD", function()
						gitsigns.diffthis("~")
					end, "Diff buffer against last commit")
					map("n", "<leader>td", gitsigns.toggle_deleted, "Toggle deleted")

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select text in hunk")
				end,
			})

		end,
	},
}
