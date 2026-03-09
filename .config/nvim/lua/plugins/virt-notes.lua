return {
  "aaron-p1/virt-notes.nvim",
  config = function()
    require("virt-notes").setup({
      hl_group = "lualine_a_visual",
      mappings = {
        prefix = "<Leader>N",
      },
    })

    local notes_mod = require("virt-notes.notes")

    -- Get sorted line numbers with notes in current buffer
    local function get_note_lines()
      local all_notes = notes_mod.get_all_notes(0)
      local lines = {}
      for line, _ in pairs(all_notes) do
        table.insert(lines, line)
      end
      table.sort(lines)
      return lines
    end

    -- Jump to next note
    local function goto_next_note()
      local lines = get_note_lines()
      if #lines == 0 then
        vim.notify("No notes in buffer", vim.log.levels.INFO)
        return
      end
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
      for _, line in ipairs(lines) do
        if line > cursor_line then
          vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
          return
        end
      end
      -- Wrap to first note
      vim.api.nvim_win_set_cursor(0, { lines[1] + 1, 0 })
    end

    -- Jump to previous note
    local function goto_prev_note()
      local lines = get_note_lines()
      if #lines == 0 then
        vim.notify("No notes in buffer", vim.log.levels.INFO)
        return
      end
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
      for i = #lines, 1, -1 do
        if lines[i] < cursor_line then
          vim.api.nvim_win_set_cursor(0, { lines[i] + 1, 0 })
          return
        end
      end
      -- Wrap to last note
      vim.api.nvim_win_set_cursor(0, { lines[#lines] + 1, 0 })
    end

    -- Telescope picker for notes in current buffer
    local function find_notes_telescope()
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local entry_display = require("telescope.pickers.entry_display")

      local bufnr = vim.api.nvim_get_current_buf()
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local all_notes = notes_mod.get_all_notes(bufnr)
      local entries = {}
      for line, note_list in pairs(all_notes) do
        local line_content = buf_lines[line + 1] or ""
        for _, note_text in ipairs(note_list) do
          table.insert(entries, {
            line = line + 1, -- 1-indexed for display
            text = note_text,
            line_content = vim.trim(line_content),
            path = filepath,
          })
        end
      end
      table.sort(entries, function(a, b)
        return a.line < b.line
      end)

      if #entries == 0 then
        vim.notify("No notes in buffer", vim.log.levels.INFO)
        return
      end

      local displayer = entry_display.create({
        separator = " ",
        items = {
          { width = 5 },
          { width = 30 },
          { remaining = true },
        },
      })

      pickers
        .new({}, {
          prompt_title = "Virt Notes",
          finder = finders.new_table({
            results = entries,
            entry_maker = function(entry)
              return {
                value = entry,
                display = function(e)
                  return displayer({
                    { e.value.line },
                    { e.value.text },
                    { e.value.line_content, "NonText" },
                  })
                end,
                ordinal = entry.text .. " " .. entry.line_content,
                lnum = entry.line,
                path = entry.path,
                filename = entry.path,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          previewer = conf.grep_previewer({}),
          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
              end
            end)
            return true
          end,
        })
        :find()
    end

    -- Keymaps
    vim.keymap.set("n", "]n", goto_next_note, { desc = "Next virt-note" })
    vim.keymap.set("n", "[n", goto_prev_note, { desc = "Previous virt-note" })
    vim.keymap.set("n", "<Leader>fn", find_notes_telescope, { desc = "Find virt-notes in buffer" })
  end,
}
