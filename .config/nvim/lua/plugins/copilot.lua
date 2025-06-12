return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	-- enabled = false,
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = false,
				hide_during_completion = true,
				debounce = 75,
				trigger_on_accept = true,
				keymap = {
					accept = "<F4>",
					accept_word = "<F3>",
					accept_line = false,
					next = false,
					prev = "<F2>",
					dismiss = "<C-]>",
				},
			},
		})
		vim.keymap.set("i", "<F1>", function()
			vim.cmd.fclose()
			require("copilot.suggestion").next()
		end)
		-- 	local cmp = require("cmp")
		-- 	cmp.event:on("menu_opened", function()
		-- 		vim.b.copilot_suggestion_hidden = true
		-- 	end)
		--
		-- 	cmp.event:on("menu_closed", function()
		-- 		vim.b.copilot_suggestion_hidden = false
		-- 	end)
	end,
}
