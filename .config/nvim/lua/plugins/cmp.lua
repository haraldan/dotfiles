return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
			},
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"chrisgrieser/cmp_yanky",
			"dmitmel/cmp-cmdline-history",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				-- preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-c>"] = cmp.mapping.complete(),
					["<ESC>"] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.abort()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.confirm({ select = false })
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-n>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-p>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
					["<C-e>"] = cmp.mapping(function()
						if luasnip.choice_active() then
							luasnip.change_choice(1)
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "cmp_yanky" },
				}),
			})
			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
					{ name = "cmdline_history" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({

					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}, {
					{ name = "cmdline_history" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
