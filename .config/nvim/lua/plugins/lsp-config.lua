return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "vhdl_ls", "basedpyright", "bashls", "html", "autohotkey_lsp" },
				automatic_enable = true,
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

			local vhdl_capabilities = capabilities
			vhdl_capabilities.textDocument.completion.completionItem.snippetSupport = false

			-- LSP configurations
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--compile-commands-dir=" .. vim.fn.expand("~/.clangd"),
					"--query-driver=/opt/**",
					"--clang-tidy",
				},
				single_file_support = false,
			})
			local compile_commands_path = vim.fn.expand("~/.clangd/compile_commands.json")
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
				callback = function()
					local source = vim.fn.getcwd() .. "/compile_commands.json"
					if vim.fn.filereadable(source) == 1 then
						vim.fn.system({ "ln", "-sf", source, compile_commands_path })
					end
				end,
			})

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						hint = { enable = true },
					},
				},
			})
			vim.lsp.config("vhdl_ls", {
				capabilities = vhdl_capabilities,
			})
			vim.lsp.config("basedpyright", {
				capabilities = capabilities,
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "standard",
							autoFormatStrings = true,
							inlayHints = {
								variableTypes = false,
								callArgumentNames = true,
								functionReturnTypes = true,
							},
						},
					},
				},
			})
			vim.lsp.config("html", {
				capabilities = capabilities,
			})
			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				capabilities = capabilities,
				single_file_support = true,
			})
			vim.lsp.config("autohotkey_lsp", {
				capabilities = capabilities,
				single_file_support = true,
				-- Suppress the interpreter not found request
				handlers = {
					["window/showMessageRequest"] = function(err, result, ctx, config)
						if result and result.message and result.message:find("[Ii]nterpreter") then
							return vim.NIL
						end
						return vim.lsp.handlers["window/showMessageRequest"](err, result, ctx, config)
					end,
				},
			})

			vim.diagnostic.config({
				float = { border = "single" },
				virtual_text = true,
			})

			-- Set up mappings
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
				callback = function(event)
					local with_flash = require("config.flash_on_jump").with_flash_async

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", with_flash(vim.lsp.buf.definition), "[G]oto [D]efinition")
					map("gr", with_flash(require("telescope.builtin").lsp_references), "[G]oto [R]eferences")
					map("gI", with_flash(require("telescope.builtin").lsp_implementations), "[G]oto [I]mplementation")
					map("gD", with_flash(vim.lsp.buf.declaration), "[G]oto [D]eclaration")
					map("gt", with_flash(require("telescope.builtin").lsp_type_definitions), "[T]ype [D]efinition")
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
						":LspClangdSwitchSourceHeader<CR>",
						{ desc = "LSP: Switch header/source", silent = true }
					)
					vim.keymap.set("n", "<leader>li", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
					end, { desc = "LSP: Toggle inlay hints" })

					-- Client-dependent functions
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.name == "basedpyright" then
						vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
					end
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
