return {
  "gbprod/yanky.nvim",
  config = function()
    local mapping = require("yanky.telescope.mapping")

    require("yanky").setup({
      ring = {
        history_length = 100,
        storage = "shada",
        sync_with_numbered_registers = true,
        cancel_event = "update",
        ignore_registers = { "_" },
        update_register_on_cycle = false,
      },
      system_clipboard = {
        sync_with_ring = true,
      },
      preserve_cursor_position = {
        enabled = true,
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 200,
      },
      picker = {
        telescope = {
          use_default_mappings = false,
          mappings = {
            default = mapping.put("p"),
            i = {
              ["<c-x>"] = mapping.delete(),
            },
            n = {
              p = mapping.put("p"),
              P = mapping.put("P"),
              ["<c-x>"] = mapping.delete(),
            },
          },
        },
      },
    })

    vim.api.nvim_set_hl(0, 'YankyYanked', { bg = "#3b4261" })
    vim.api.nvim_set_hl(0, 'YankyPut', { bg = "#3b4261" })

    require("telescope").load_extension("yank_history")
    vim.keymap.set("n", "<leader>fy", function()
      require("telescope").extensions.yank_history.yank_history()
    end, { desc = "[F]ind [Y]anks" })

    vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
    vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
    vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
    vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
    vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

    vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
    vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
  end,
}
