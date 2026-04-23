return {
	{
		"chrisgrieser/nvim-origami",
		enabled = false,
		event = "BufReadPost", -- later or on keypress would prevent saving folds
		opts = true, -- needed even when using default config
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "VeryLazy",
		opts = {
			-- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					-- winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					jumpTop = "[",
					jumpBot = "]",
				},
			},
		},
		init = function()
			vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
			vim.opt.foldcolumn = "1" -- '0' is not bad
			vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.opt.foldlevelstart = 99
			vim.opt.foldenable = true
		end,
		config = function(_, opts)
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local totalLines = vim.api.nvim_buf_line_count(0)
				local foldedLines = endLnum - lnum
				local suffix = (" 󰁂 %d [%d%%]"):format(foldedLines, foldedLines / totalLines * 100)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
				suffix = (" "):rep(rAlignAppndx) .. suffix
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end
			opts["fold_virt_text_handler"] = handler

			require("ufo").setup(opts)

			local function goto_prev_fold_start()
				local current_line = vim.fn.line(".")
				local bufnr = vim.api.nvim_get_current_buf()

				-- Get all fold ranges from ufo
				local ok, ufo = pcall(require, "ufo")
				if not ok then
					return
				end

				local fold_ranges = ufo.getFolds(bufnr, "treesitter") or {}

				-- Collect all fold start lines before current line
				local fold_starts = {}
				for _, range in ipairs(fold_ranges) do
					local start_line = range.startLine + 1 -- ufo uses 0-indexed
					if start_line < current_line then
						table.insert(fold_starts, start_line)
					end
				end

				if #fold_starts == 0 then
					return
				end

				-- Sort descending and pick the closest one
				table.sort(fold_starts, function(a, b)
					return a > b
				end)

				local target_line = fold_starts[1]
				vim.cmd("normal! m'") -- set jump mark
				vim.api.nvim_win_set_cursor(0, { target_line, 0 })
				vim.cmd("normal! ^") -- go to first non-blank
			end

			vim.keymap.set("n", "[z", goto_prev_fold_start, { desc = "Jump to previous fold", noremap = true })
			vim.keymap.set("n", "]z", "zj^", { desc = "Jump to next fold" })
			vim.keymap.set("n", "<leader>z", "za", { desc = "Toggle fold under cursor" })
		end,
	},
}
