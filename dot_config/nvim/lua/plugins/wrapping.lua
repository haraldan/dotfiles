return {
	{ "rickhowe/wrapwidth",
		config = function()
			local function notify_soft_wrap(state)
				local message = "Soft wrap " .. state
				vim.api.nvim_echo(
					{ { message } },
					true,
					{ kind = "progress", status = "success", source = "wrapwidth", title = "" }
				)
			end

			local function enable_soft_wrap()
				vim.opt_local.wrap = true
				vim.keymap.set("n", "j", "gj", { buffer = true })
				vim.keymap.set("n", "k", "gk", { buffer = true })
				vim.keymap.set("n", "0", "g0", { buffer = true })
				vim.keymap.set("n", "^", "g^", { buffer = true })
				vim.keymap.set("n", "$", "g$", { buffer = true })
				vim.keymap.set("n", "I", "g^i", { buffer = true })
				vim.keymap.set("n", "A", "g$a", { buffer = true })
				vim.cmd("Wrapwidth " .. vim.o.textwidth)
				vim.b.soft_wrap_enabled = true
				notify_soft_wrap("enabled")
			end

			local function disable_soft_wrap()
				vim.opt_local.wrap = false
				for _, lhs in ipairs({ "j", "k", "0", "^", "$", "I", "A" }) do
					vim.keymap.del("n", lhs, { buffer = true })
				end
				vim.b.soft_wrap_enabled = false
				notify_soft_wrap("disabled")
			end

			vim.keymap.set("n", "<leader>ww", function()
				if vim.b.soft_wrap_enabled then
					disable_soft_wrap()
				else
					enable_soft_wrap()
				end
			end, { desc = "Toggle soft wrap mode" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "tex", "markdown", "bib" },
				callback = function(event)
					if vim.bo[event.buf].buftype ~= "" then
						return
					end
					if not vim.b.soft_wrap_enabled then
						enable_soft_wrap()
					end
					vim.opt_local.spell = true
				end,
			})
		end,
	},
}
