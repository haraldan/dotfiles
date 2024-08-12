return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
    	options = {
    		theme = "auto",
    		ignore_focus = {
    			"dapui_watches",
    			"dapui_breakpoints",
    			"dapui_scopes",
    			"dapui_console",
    			"dapui_stacks",
    			"dap-repl",
    		},
    	},
    	sections = {
    		lualine_c = { require("auto-session.lib").current_session_name, "filename" },
    		lualine_x = { "filetype", "%{&fo}" },
    	},
    })
  end,
}
