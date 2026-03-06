return {
	"monaqa/dial.nvim",
	keys = {
		{ "<C-a>", mode = { "n", "v" } },
		{ "<C-z>", mode = { "n", "v" } },
		{ "g<C-a>", mode = "v" },
		{ "g<C-z>", mode = "v" },
	},
	config = function()
		local augend = require("dial.augend")
		local config = require("dial.config")

		local default_augends = {
			augend.integer.alias.decimal_int,
			augend.integer.alias.hex,
			augend.integer.alias.octal,
			augend.integer.alias.binary,
			augend.constant.alias.bool,
			augend.constant.alias.Bool,
			augend.semver.alias.semver,
			augend.constant.alias.en_weekday,
			augend.constant.alias.en_weekday_full,
			augend.date.alias["%H:%M:%S"],
			augend.date.alias["%H:%M"],
			augend.date.alias["%d/%m/%Y"],
			augend.date.alias["%Y-%m-%d"],
			augend.date.new({
				pattern = "%Y%m%d",
				default_kind = "day",
			}),
			augend.constant.new({
				elements = { "&&", "||" },
				word = false,
				cyclic = true,
			}),
			augend.constant.new({
				elements = { "+", "-" },
				word = true,
				cyclic = true,
			}),
		}

		local python_augends = vim.list_extend(vim.deepcopy(default_augends), {
			augend.constant.new({
				elements = { "and", "or" },
				word = true,
				cyclic = true,
			}),
		})

		local c_augends = vim.list_extend(vim.deepcopy(default_augends), {
			augend.constant.new({
				elements = { "ifdef", "ifndef" },
				word = false,
				cyclic = true,
			}),
		})

		-- Register groups
		config.augends:register_group({
			default = default_augends,
		})

		config.augends:on_filetype({
			python = python_augends,
			c = c_augends,
			cpp = c_augends,
		})

		-- Set up keymaps
		vim.keymap.set("n", "<C-a>", function()
			require("dial.map").manipulate("increment", "normal")
		end)
		vim.keymap.set("n", "<C-z>", function()
			require("dial.map").manipulate("decrement", "normal")
		end)
		vim.keymap.set("v", "<C-a>", function()
			require("dial.map").manipulate("increment", "visual")
		end)
		vim.keymap.set("v", "<C-z>", function()
			require("dial.map").manipulate("decrement", "visual")
		end)
		vim.keymap.set("v", "g<C-a>", function()
			require("dial.map").manipulate("increment", "gvisual")
		end)
		vim.keymap.set("v", "g<C-z>", function()
			require("dial.map").manipulate("decrement", "gvisual")
		end)
	end,
}
