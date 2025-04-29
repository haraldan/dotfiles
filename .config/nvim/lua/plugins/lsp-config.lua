return {
	{
		"williamboman/mason-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				-- automatic_installation = true, -- currently not working in 0.11
				ensure_installed = { "clangd", "lua_ls", "vhdl_ls", "pyright", "bashls", "matlab_ls", "html" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- LSP configurations
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--query-driver=/opt/**/*gcc",
					"--clang-tidy",
				},
				single_file_support = false,
			})
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})
			vim.lsp.config("vhdl_ls", {
				capabilities = capabilities,
			})
			vim.lsp.config("pyright", {
				capabilities = capabilities,
			})
			vim.lsp.config("html", {
				capabilities = capabilities,
			})
			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				capabilities = capabilities,
				single_file_support = true,
			})
			vim.lsp.config("matlab_ls", {
				capabilities = capabilities,
				filetypes = { "matlab" },
				settings = {
					matlab = {
						installPath = "/usr/local/MATLAB/R2024b/",
					},
				},
				single_file_support = true,
			})

			-- Enable LSP
			vim.lsp.enable("clangd")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("vhdl_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("html")
			vim.lsp.enable("bashls")
			vim.lsp.enable("matlab_ls")

			vim.diagnostic.config({
				float = { border = "single" },
				virtual_text = true,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gt", require("telescope.builtin").lsp_type_definitions, "[T]ype [D]efinition")
					map("]e", function()
						vim.diagnostic.goto_next({ float = false, severity = { vim.diagnostic.severity.ERROR } })
					end, "[G]oto next [E]rror")
					map("[e", function()
						vim.diagnostic.goto_prev({ float = false, severity = { vim.diagnostic.severity.ERROR } })
					end, "[G]oto prev [E]rror")

					map("<leader>ld", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>lw",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>lr", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>lc", vim.lsp.buf.code_action, "[C]ode [A]ction")
					vim.keymap.set("n", "<leader>lt", function()
						vim.diagnostic.enable(not vim.diagnostic.is_enabled())
					end, { silent = true, noremap = true, desc = "LSP: Toggle Diagnostics" })
					vim.keymap.set(
						"n",
						"<leader>lh",
						":ClangdSwitchSourceHeader<CR>",
						{ desc = "LSP: Switch header/source", silent = true }
					)

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
				end,
			})
		end,
	},
}
