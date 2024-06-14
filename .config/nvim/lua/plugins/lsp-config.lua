return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.black,
				},
			})
			require("mason-null-ls").setup({
				automatic_installation = true,
			})

			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Auto-format using LSP/null-ls" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local lspconfig = require("lspconfig")

			require("mason-lspconfig").setup({
				automatic_installation = true,
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
				-- cmd = {"clangd-12", '--query-driver=/opt/arm-gnu-toolchain-13_2/bin/arm-none-eabi-gcc', "--pretty", "--clang-tidy"},
				-- cmd = {"clangd-12", '--query-driver=/usr/bin/arm-none-eabi-gcc'},
				cmd = {
					"clangd",
					"--query-driver=/home/ds/.local/bin/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin/*gcc",
					"--clang-tidy",
				},
				single_file_support = false,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.vhdl_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("ge", function()
						vim.diagnostic.goto_next({ float = false })
					end, "[G]oto next [E]rror")
					map("gE", function()
						vim.diagnostic.goto_prev({ float = false })
					end, "[G]oto prev [E]rror")

					map("<leader>td", require("telescope.builtin").lsp_type_definitions, "[T]ype [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end

					-- add border to hover windows
					local _border = "single"

					vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
						border = _border,
					})

					vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
						border = _border,
					})

					vim.diagnostic.config({
						float = { border = _border },
					})
				end,
			})
		end,
	},
}
