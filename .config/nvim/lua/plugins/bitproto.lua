return {
	"hit9/bitproto",
	config = function(plugin)
		vim.opt.rtp:append(plugin.dir .. "/editors/vim")
	end,
	init = function(plugin)
		require("lazy.core.loader").ftdetect(plugin.dir .. "/editors/vim")
	end,
}
