{
  pkgs,
  lib,
  ...
}: {
  packages = with pkgs; [
    bash-language-server
    clang-tools
    fenix.rust-analyzer
    gopls
    lua-language-server
    nixd
    alejandra
    ols
    zls
  ];

  config = with pkgs.vimPlugins; ''
    {
      dir = "${nvim-lspconfig}",
      name = "nvim-lspconfig",
    	dependencies = {
        { dir = "${neodev-nvim}", name = "neodev-nvim", },
        { dir = "${telescope-nvim}", name = "telescope-nvim", },
    	},

    	config = function()
    		--- @param args { buf: integer }
    		local on_attach = function(args)
    			local bufnr = args.buf

    			--- @param keys string
    			--- @param func function
    			local bufmap = function(keys, func)
    				vim.keymap.set('n', keys, func, { buffer = bufnr })
    			end

    			bufmap('<leader>rn', vim.lsp.buf.rename)
    			bufmap('<leader>.', vim.lsp.buf.code_action)

    			bufmap('gd', vim.lsp.buf.definition)
    			bufmap('gD', vim.lsp.buf.declaration)
    			bufmap('gI', vim.lsp.buf.implementation)
    			bufmap('<leader>D', vim.lsp.buf.type_definition)

    			local telescope = require('telescope.builtin')
    			bufmap('gr', telescope.lsp_references)
    			bufmap('gs', telescope.lsp_document_symbols)
    			bufmap('gS', telescope.lsp_dynamic_workspace_symbols)

    			bufmap("[d", vim.diagnostic.goto_prev)
    			bufmap("]d", vim.diagnostic.goto_next)

    			bufmap('K', vim.lsp.buf.hover)

    			vim.api.nvim_create_autocmd('BufWritePre', {
    				buffer = bufnr,
    				callback = function(_)
    					vim.lsp.buf.format()
    				end
    			})
    		end

    		local capabilities = vim.lsp.protocol.make_client_capabilities()
    		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    		require("neodev").setup()

    		local servers = {
    			lua_ls = {
    				Lua = {
    					workspace = { checkThirdParty = false },
    					telemetry = { enable = false },
    				},
    			},

    			rust_analyzer = {
    				["rust-analyzer"] = {
    					cargo = { allFeatures = true, },
    					imports = { group = { enable = false, }, },
    					completion = { postfix = { enable = false, }, },
    					check = { command = "clippy" }
    				}
    			},

    			gopls = {},

    			nixd = {
    				settings = {
    					nixd = {
    						formatting = {
    							command = { "alejandra" },
    						},
    					}
    				},
    			},

    			bashls = {},

    			pylsp = {},

    			clangd = {},

    			zls = {
    				settings = {},

    				on_attach = function(...)
    					vim.g.zig_fmt_autosave = false
    				end,
    			},

    			ols = {
    				init_options = {
    					checker_args = "-strict-style",
    				},
    			},
    		}

    		local lspconfig = require("lspconfig")
    		for name, config in pairs(servers) do
    			if config.settings == nil then
    				config = { settings = config }
    			end

    			config = vim.tbl_deep_extend("force", {}, {
    				capabilities = capabilities,
    			}, config)

    			lspconfig[name].setup(config)
    		end

    		vim.api.nvim_create_autocmd("LspAttach", {
    			callback = on_attach,
    		})
    	end
    },
  '';
}
