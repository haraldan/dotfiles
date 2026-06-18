-- telegram_delete.lua
-- Neovim plugin to mark Telegram chat messages for deletion.
--
-- Workflow:
--   * Open a CSV file named `{ChatName}_{ChatID}.csv`.
--   * Existing marks for that chat (read from `../to_delete.json`) are shown
--     with a red `✗` sign in the gutter and a full-line red underline.
--   * Press <CR> in normal mode to mark the line under the cursor.
--   * Press <CR> in visual mode to mark all selected lines.
--   * Marks are persisted to `../to_delete.json` immediately.

local M = {}

-- Module-level per-buffer state: M.state[bufnr] = { chat_id = "...", marked = {} }
-- `marked` is a set: marked[msg_id_int] = true
M.state = {}

local ns_id = vim.api.nvim_create_namespace("telegram_delete")
local SIGN_GROUP = "telegram_delete"
local SIGN_NAME = "TelegramDelete"

-- Parse the first CSV field of a line as a msg_id integer.
-- Returns nil for the header row, empty lines, and quoted values.
local function get_msg_id(line)
  local id = line:match("^(%d+),")
  return id and tonumber(id) or nil
end

-- Resolve the path to ../to_delete.json relative to a buffer's CSV file.
local function json_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return vim.fn.fnamemodify(name, ":h:h") .. "/to_delete.json"
end

-- Read and decode the JSON file. Returns a table (empty if missing/invalid).
local function read_json(path)
  if vim.fn.filereadable(path) == 0 then
    return {}
  end
  local lines = vim.fn.readfile(path)
  if not lines or #lines == 0 then
    return {}
  end
  local ok, data = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok or type(data) ~= "table" then
    return {}
  end
  return data
end

-- Encode and write the JSON file, pretty-printed via jq if available.
local function write_json(path, data)
  local encoded = vim.fn.json_encode(data)
  local pretty = vim.fn.system("jq .", encoded)
  vim.fn.writefile(vim.split(vim.v.shell_error == 0 and pretty or encoded, "\n"), path)
end

-- Ensure highlight groups and the sign are defined.
local function ensure_visuals()
  vim.api.nvim_set_hl(0, "TelegramDeleteSign", { fg = "#ff5555", bold = true })
  vim.api.nvim_set_hl(0, "TelegramDeleteMsgId", { fg = "#ff5555", underline = true })
  vim.fn.sign_define(SIGN_NAME, { text = "✗", texthl = "TelegramDeleteSign" })
end

-- Apply the sign + full-line underline to a single (1-based) line.
local function highlight_line(bufnr, lnum)
  vim.fn.sign_place(0, SIGN_GROUP, SIGN_NAME, bufnr, { lnum = lnum, priority = 10 })
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, "TelegramDeleteMsgId", lnum - 1, 0, -1)
end

-- Clear all telegram_delete visuals from a buffer.
local function clear_visuals(bufnr)
  vim.fn.sign_unplace(SIGN_GROUP, { buffer = bufnr })
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

-- Scan the whole buffer and (re)apply highlights for all currently marked ids.
local function refresh_highlights(bufnr)
  local st = M.state[bufnr]
  if not st then
    return
  end
  clear_visuals(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    local msg_id = get_msg_id(line)
    if msg_id and st.marked[msg_id] then
      highlight_line(bufnr, i)
    end
  end
end

-- Apply/refresh deletion-mark highlights in the quickfix window.
local function refresh_qf_highlights()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if not qf_winid or qf_winid == 0 then
    return
  end
  local qf_bufnr = vim.api.nvim_win_get_buf(qf_winid)
  vim.api.nvim_buf_clear_namespace(qf_bufnr, ns_id, 0, -1)
  local items = vim.fn.getqflist()
  local data_cache = {}
  local set_cache = {}
  for i, entry in ipairs(items) do
    if entry.bufnr and entry.bufnr ~= 0 then
      local filename = vim.api.nvim_buf_get_name(entry.bufnr)
      local chat_id = filename:match("_(%d+)%.csv$")
      if chat_id then
        local msg_id = get_msg_id(entry.text)
        if msg_id then
          local jp = vim.fn.fnamemodify(filename, ":h:h") .. "/to_delete.json"
          local key = jp .. "|" .. chat_id
          if not set_cache[key] then
            if not data_cache[jp] then
              data_cache[jp] = read_json(jp)
            end
            local s = {}
            local ids = data_cache[jp][chat_id]
            if type(ids) == "table" then
              for _, id in ipairs(ids) do
                s[tonumber(id)] = true
              end
            end
            set_cache[key] = s
          end
          if set_cache[key][msg_id] then
            vim.api.nvim_buf_add_highlight(qf_bufnr, ns_id, "TelegramDeleteMsgId", i - 1, 0, -1)
          end
        end
      end
    end
  end
end

-- Called when entering a CSV buffer: detect chat id, load marks, highlight.
function M.on_buf_enter()
  local bufnr = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return
  end

  -- Extract chat id from filename: {ChatName}_{ChatID}.csv
  local chat_id = name:match("_(%d+)%.csv$")
  if not chat_id then
    return
  end

  ensure_visuals()

  -- Switch to komau for CSV files. Deferred via vim.schedule because changing
  -- the colorscheme directly inside BufEnter only repaints the command line;
  -- scheduling lets the window redraw. Guarded to avoid needless reloads.
  -- Our highlight groups are restored by the ColorScheme autocmd in setup().
  if vim.g.colors_name ~= "komau" then
    vim.schedule(function()
      vim.cmd.colorscheme("komau")
    end)
  end

  -- Load marks for this chat from JSON into a set.
  local data = read_json(json_path(bufnr))
  local marked = {}
  local ids = data[chat_id]
  if type(ids) == "table" then
    for _, id in ipairs(ids) do
      marked[tonumber(id)] = true
    end
  end

  -- CSV rows are long single lines; the colorcolumn just adds noise.
  vim.api.nvim_set_option_value("colorcolumn", "", { win = 0 })

  M.state[bufnr] = { chat_id = chat_id, marked = marked }
  refresh_highlights(bufnr)

  -- Set buffer-local keymaps (idempotent).
  vim.keymap.set("n", "<CR>", function()
    require("telegram_delete").mark_selected(false)
  end, { buffer = bufnr, desc = "Mark message for deletion" })

  -- Use a <Cmd> mapping for visual mode: it does NOT leave visual mode, so the
  -- selection stays active and we can read the LIVE range via getpos("v") and
  -- getpos("."). (A plain function mapping exits visual mode and the '< / '>
  -- marks still hold the *previous* selection at callback time — the bug we hit.)
  vim.keymap.set("x", "<CR>", "<Cmd>lua require('telegram_delete').mark_selected(true)<CR>",
    { buffer = bufnr, desc = "Mark messages for deletion" })

  -- Select the whole file (overrides any existing <C-a> mapping in this buffer).
  vim.keymap.set("n", "<C-a>", "ggVG", { buffer = bufnr, desc = "Select all" })
end

-- Mark the cursor line (normal) or the visual selection (visual).
-- use_visual=true: read the live selection via getpos (invoked from a <Cmd>
-- mapping, so we are still in visual mode and the selection is preserved).
function M.mark_selected(use_visual)
  local bufnr = vim.api.nvim_get_current_buf()
  local st = M.state[bufnr]
  if not st then
    M.on_buf_enter()
    st = M.state[bufnr]
    if not st then
      return
    end
  end

  local start_lnum, end_lnum
  if use_visual then
    -- getpos("v") = visual anchor, getpos(".") = cursor; [2] is the line number.
    start_lnum = vim.fn.getpos("v")[2]
    end_lnum = vim.fn.getpos(".")[2]
  else
    local cur = vim.api.nvim_win_get_cursor(0)
    start_lnum, end_lnum = cur[1], cur[1]
  end

  if start_lnum > end_lnum then
    start_lnum, end_lnum = end_lnum, start_lnum
  end

  -- Collect every selectable (msg_id-bearing) line in the range.
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_lnum - 1, end_lnum, false)
  local targets = {}
  local all_marked = true
  for idx, line in ipairs(lines) do
    local msg_id = get_msg_id(line)
    if msg_id then
      targets[#targets + 1] = { lnum = start_lnum + idx - 1, msg_id = msg_id }
      if not st.marked[msg_id] then
        all_marked = false
      end
    end
  end

  if #targets == 0 then
    return
  end

  -- Toggle behavior with "mark-all-first" semantics: only unmark when every
  -- selected line is already marked; otherwise mark all of them.
  local unmark = all_marked
  for _, item in ipairs(targets) do
    st.marked[item.msg_id] = (not unmark) or nil
  end

  -- Persist to JSON.
  local path = json_path(bufnr)
  local data = read_json(path)
  -- Rebuild this chat's id list from the in-memory set (sorted for readability).
  local ids = {}
  for id in pairs(st.marked) do
    ids[#ids + 1] = id
  end
  table.sort(ids)
  data[st.chat_id] = #ids > 0 and ids or nil
  write_json(path, data)

  -- Re-apply highlights across the whole buffer to reflect the new state
  -- (handles both added and removed marks).
  refresh_highlights(bufnr)
  refresh_qf_highlights()
end

-- Mark rg --vimgrep entries that fall inside Telegram CSV files.
-- Extracts chat_id from each filename and msg_id from each matched line,
-- merges them into to_delete.json, and syncs any open buffer for that chat.
function M.mark_from_rg_entries(entries)
  local groups = {}
  for _, entry in ipairs(entries) do
    local chat_id = entry.filename:match("_(%d+)%.csv$")
    if chat_id then
      local msg_id = get_msg_id(entry.text)
      if msg_id then
        local jp = vim.fn.fnamemodify(entry.filename, ":h:h") .. "/to_delete.json"
        local key = jp .. "|" .. chat_id
        if not groups[key] then
          groups[key] = { path = jp, chat_id = chat_id, ids = {} }
        end
        groups[key].ids[#groups[key].ids + 1] = msg_id
      end
    end
  end
  for _, g in pairs(groups) do
    local data = read_json(g.path)
    local set = {}
    if type(data[g.chat_id]) == "table" then
      for _, id in ipairs(data[g.chat_id]) do
        set[tonumber(id)] = true
      end
    end
    for _, id in ipairs(g.ids) do
      set[id] = true
    end
    local ids = {}
    for id in pairs(set) do
      ids[#ids + 1] = id
    end
    table.sort(ids)
    data[g.chat_id] = ids
    write_json(g.path, data)
    for bufnr, st in pairs(M.state) do
      if st.chat_id == g.chat_id then
        for _, id in ipairs(g.ids) do
          st.marked[id] = true
        end
        refresh_highlights(bufnr)
      end
    end
  end
  refresh_qf_highlights()
end

-- Toggle the deletion mark for the quickfix entry under the cursor.
function M.toggle_qf_entry()
  local items = vim.fn.getqflist()
  local entry = items[vim.fn.line('.')]
  if not entry or not entry.bufnr or entry.bufnr == 0 then
    return
  end
  local filename = vim.api.nvim_buf_get_name(entry.bufnr)
  local chat_id = filename:match("_(%d+)%.csv$")
  if not chat_id then
    return
  end
  local msg_id = get_msg_id(entry.text)
  if not msg_id then
    return
  end
  local jp = vim.fn.fnamemodify(filename, ":h:h") .. "/to_delete.json"
  local data = read_json(jp)
  local set = {}
  if type(data[chat_id]) == "table" then
    for _, id in ipairs(data[chat_id]) do
      set[tonumber(id)] = true
    end
  end
  if set[msg_id] then
    set[msg_id] = nil
  else
    set[msg_id] = true
  end
  local ids = {}
  for id in pairs(set) do
    ids[#ids + 1] = id
  end
  table.sort(ids)
  data[chat_id] = #ids > 0 and ids or nil
  write_json(jp, data)
  for bufnr, st in pairs(M.state) do
    if st.chat_id == chat_id then
      st.marked[msg_id] = set[msg_id] or nil
      refresh_highlights(bufnr)
    end
  end
  refresh_qf_highlights()
end

-- Register the autocmd. Safe to call multiple times.
function M.setup()
  ensure_visuals()

  local group = vim.api.nvim_create_augroup("TelegramDelete", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = group,
    pattern = "*.csv",
    callback = function()
      require("telegram_delete").on_buf_enter()
    end,
  })

  -- Re-define our highlight groups after any colorscheme change (a colorscheme
  -- load clears custom groups), so marked lines keep their red.
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = ensure_visuals,
  })

  -- <leader><CR> in any quickfix window toggles the deletion mark for the entry.
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "qf",
    callback = function()
      vim.keymap.set("n", "<leader><CR>", function()
        require("telegram_delete").toggle_qf_entry()
      end, { buffer = true, desc = "Toggle message deletion mark" })
      refresh_qf_highlights()
    end,
  })

  -- Clean up per-buffer state when buffers are wiped out.
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    pattern = "*.csv",
    callback = function(args)
      M.state[args.buf] = nil
    end,
  })
end

return M
