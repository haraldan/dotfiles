return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    toggler = {
      ---Line-comment toggle keymap
      line = "<leader>cc",
      ---Block-comment toggle keymap
      block = "<leader>cb",
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
      ---Line-comment keymap
      line = "<leader>cc",
      ---Block-comment keymap
      block = "<leader>cb",
    },
  },
}
