local M = {
  _active_pattern = nil,
  _match_ids = {},
  _autocmd_id = nil,
}

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'WordSearchMatch', { bg = '#fabd2f', fg = '#1d2021', bold = true })
  vim.api.nvim_set_hl(0, 'WordSearchQF', { fg = '#fabd2f', bold = true, underline = true })
end

function M.clear()
  for winid, match_id in pairs(M._match_ids) do
    pcall(vim.api.nvim_win_call, winid, function()
      pcall(vim.fn.matchdelete, match_id)
    end)
  end
  M._match_ids = {}

  if M._autocmd_id then
    pcall(vim.api.nvim_del_autocmd, M._autocmd_id)
    M._autocmd_id = nil
  end

  M._active_pattern = nil
end

function M.clear_all()
  M.clear()
  vim.fn.setqflist({}, 'r', { title = '', items = {} })
  vim.cmd('cclose')
end

function M._apply_highlights_all_windows()
  if not M._active_pattern then
    return
  end
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if not M._match_ids[winid] then
      vim.api.nvim_win_call(winid, function()
        M._match_ids[winid] = vim.fn.matchadd('WordSearchMatch', M._active_pattern)
      end)
    end
  end
end

function M.search(filepath)
  if filepath == nil or filepath == '' then
    vim.notify('WordSearch: no file given', vim.log.levels.ERROR)
    return
  end

  if not filepath:match('^/') then
    filepath = vim.fn.getcwd() .. '/' .. filepath
  end

  if vim.fn.filereadable(filepath) == 0 then
    vim.notify('WordSearch: file not readable: ' .. filepath, vim.log.levels.ERROR)
    return
  end

  local forms = {}
  for _, line in ipairs(vim.fn.readfile(filepath)) do
    local trimmed = vim.fn.trim(line)
    if trimmed ~= '' and not trimmed:match('^#') then
      forms[#forms + 1] = trimmed
    end
  end

  if #forms == 0 then
    vim.notify('WordSearch: no forms in ' .. filepath, vim.log.levels.ERROR)
    return
  end

  local cwd = vim.fn.getcwd()
  local rg_pattern = table.concat(forms, '|')
  local cmd = { 'rg', '--vimgrep', '-i', '-w', '-e', rg_pattern, cwd }
  local output = vim.fn.systemlist(cmd)

  local entries = {}
  for _, line in ipairs(output) do
    local file, lnum, col, text = line:match('^(.-):(%d+):(%d+):(.*)')
    if file then
      entries[#entries + 1] = {
        filename = file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text,
      }
    end
  end

  vim.fn.setqflist({}, 'r', { title = 'WordSearch: ' .. filepath, items = entries })
  vim.cmd('copen')
  vim.notify('WordSearch: ' .. #entries .. ' matches', vim.log.levels.INFO)
  vim.notify('WordSearch: marking found lines for deletion...', vim.log.levels.INFO)
  require('telegram_delete').mark_from_rg_entries(entries)
  vim.notify('WordSearch: done marking', vim.log.levels.INFO)

  local escaped = {}
  for _, form in ipairs(forms) do
    escaped[#escaped + 1] = vim.fn.escape(form, '\\()[]{}.*+?^$|')
  end
  table.sort(escaped, function(a, b) return #a > #b end)
  local pattern = '\\c\\<\\(' .. table.concat(escaped, '\\|') .. '\\)\\>'

  M.clear()
  M._active_pattern = pattern
  M._apply_highlights_all_windows()

  M._autocmd_id = vim.api.nvim_create_autocmd('WinEnter', {
    group = vim.api.nvim_create_augroup('WordSearchHighlight', { clear = true }),
    callback = function()
      M._apply_highlights_all_windows()
    end,
  })

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.fn.win_gettype(win) == 'quickfix' then
      vim.api.nvim_win_call(win, function()
        vim.fn.matchadd('WordSearchQF', pattern)
      end)
    end
  end
end

function M.setup()
  setup_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', { callback = setup_highlights })
  vim.api.nvim_create_user_command('WordSearch', function(opts)
    M.search(opts.args)
  end, { nargs = 1, complete = 'file' })
  vim.api.nvim_create_user_command('WordSearchClear', function()
    M.clear_all()
  end, {})
end

return M
