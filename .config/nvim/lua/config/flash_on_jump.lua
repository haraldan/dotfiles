-- Flash the current line after bracket navigation jumps (like Aerial's highlight_on_jump)
local M = {}

local ns = vim.api.nvim_create_namespace("BracketFlash")
local flash_duration = 300

function M.flash_line()
	local bufnr = vim.api.nvim_get_current_buf()
	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
	local ext_id = vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, {
		end_col = #line,
		hl_group = "AerialLine",
	})
	vim.defer_fn(function()
		pcall(vim.api.nvim_buf_del_extmark, bufnr, ns, ext_id)
	end, flash_duration)
end

function M.setup()
	-- Get all [ and ] mappings and wrap them with flash
	for _, prefix in ipairs({ "[", "]" }) do
		local maps = vim.api.nvim_get_keymap("n")
		for _, map in ipairs(maps) do
			if vim.startswith(map.lhs, prefix) and map.lhs ~= prefix then
				local lhs = map.lhs
				local desc = map.desc or ""
				-- Skip if it's a recursive mapping to avoid issues
				if map.rhs and (map.rhs:match("^%[") or map.rhs:match("^%]")) then
					goto continue
				end
				-- Create wrapper
				if map.callback then
					local orig_callback = map.callback
					vim.keymap.set("n", lhs, function()
						local pos_before = vim.api.nvim_win_get_cursor(0)
						orig_callback()
						local pos_after = vim.api.nvim_win_get_cursor(0)
						if pos_before[1] ~= pos_after[1] or pos_before[2] ~= pos_after[2] then
							M.flash_line()
						end
					end, { desc = desc })
				elseif map.rhs then
					local orig_rhs = map.rhs
					vim.keymap.set("n", lhs, function()
						local pos_before = vim.api.nvim_win_get_cursor(0)
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(orig_rhs, true, true, true), "m", false)
						vim.schedule(function()
							local pos_after = vim.api.nvim_win_get_cursor(0)
							if pos_before[1] ~= pos_after[1] or pos_before[2] ~= pos_after[2] then
								M.flash_line()
							end
						end)
					end, { desc = desc })
				end
				::continue::
			end
		end
	end
end

return M
