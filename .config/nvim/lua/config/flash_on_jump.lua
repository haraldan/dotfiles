-- Flash the current line after bracket navigation jumps (like Aerial's highlight_on_jump)
local M = {}

local ns = vim.api.nvim_create_namespace("JumpFlash")
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

function M.get_visible_range()
	return vim.api.nvim_get_current_buf(), vim.fn.line("w0"), vim.fn.line("w$")
end

function M.center_if_was_outside(buf_before, top_before, bottom_before)
	local buf_after = vim.api.nvim_get_current_buf()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	if buf_before ~= buf_after or cursor_line < top_before or cursor_line > bottom_before then
		vim.cmd("normal! zz")
	end
end

-- Wrapper for sync actions (e.g., Telescope selections)
function M.with_flash_sync(fn)
	return function(...)
		local buf_before, top_before, bottom_before = M.get_visible_range()
		fn(...)
		vim.schedule(function()
			M.center_if_was_outside(buf_before, top_before, bottom_before)
			M.flash_line()
		end)
	end
end

-- Wrapper for async actions (e.g., LSP jumps)
function M.with_flash_async(fn, min_lines)
	min_lines = min_lines or 3
	return function(...)
		local buf_before = vim.api.nvim_get_current_buf()
		local pos_before = vim.api.nvim_win_get_cursor(0)
		local _, top_before, bottom_before = M.get_visible_range()
		local autocmd_id
		autocmd_id = vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
			once = true,
			callback = function()
				local buf_after = vim.api.nvim_get_current_buf()
				local pos_after = vim.api.nvim_win_get_cursor(0)
				local moved_lines = math.abs(pos_after[1] - pos_before[1])
				if buf_before ~= buf_after or moved_lines >= min_lines then
					M.center_if_was_outside(buf_before, top_before, bottom_before)
					M.flash_line()
				end
			end,
		})
		vim.defer_fn(function()
			pcall(vim.api.nvim_del_autocmd, autocmd_id)
		end, 2000)
		fn(...)
	end
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

	-- Jump list navigation
	vim.keymap.set("n", "<C-o>", function()
		local pos_before = vim.api.nvim_win_get_cursor(0)
		local buf_before = vim.api.nvim_get_current_buf()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", true, true, true), "n", false)
		vim.schedule(function()
			local pos_after = vim.api.nvim_win_get_cursor(0)
			local buf_after = vim.api.nvim_get_current_buf()
			if buf_before ~= buf_after or pos_before[1] ~= pos_after[1] or pos_before[2] ~= pos_after[2] then
				M.flash_line()
			end
		end)
	end, { desc = "Jump back" })
	vim.keymap.set("n", "<C-i>", function()
		local pos_before = vim.api.nvim_win_get_cursor(0)
		local buf_before = vim.api.nvim_get_current_buf()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-i>", true, true, true), "n", false)
		vim.schedule(function()
			local pos_after = vim.api.nvim_win_get_cursor(0)
			local buf_after = vim.api.nvim_get_current_buf()
			if buf_before ~= buf_after or pos_before[1] ~= pos_after[1] or pos_before[2] ~= pos_after[2] then
				M.flash_line()
			end
		end)
	end, { desc = "Jump forward" })

	-- Mark jumps - wrap ' and ` for all marks
	for _, char in ipairs({ "'", "`" }) do
		vim.keymap.set("n", char, function()
			local pos_before = vim.api.nvim_win_get_cursor(0)
			local buf_before = vim.api.nvim_get_current_buf()
			local mark_char = vim.fn.getcharstr()
			vim.cmd("normal! " .. char .. mark_char)
			vim.schedule(function()
				local pos_after = vim.api.nvim_win_get_cursor(0)
				local buf_after = vim.api.nvim_get_current_buf()
				if buf_before ~= buf_after or pos_before[1] ~= pos_after[1] or pos_before[2] ~= pos_after[2] then
					M.flash_line()
				end
			end)
		end, { desc = "Jump to mark" })
	end
end

return M
