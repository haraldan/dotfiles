return {
	"kwkarlwang/bufresize.nvim",
   config = function()
        require("bufresize").setup({
            register = {
                keys = {},
                trigger_events = { "BufWinEnter", "WinEnter","WinResized" },
            },
        })
    end,
}
