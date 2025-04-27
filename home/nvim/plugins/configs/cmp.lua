return {
	dir = "@nvim-cmp@",
	name = "nvim-cmp",
	dependencies = {
		{ dir = "@cmp-nvim-lsp@", name = "cmp-nvim-lsp" },
		{ dir = "@luasnip@",      name = "luasnip" },
		{ dir = "@cmp_luasnip@",  name = "cmp_luasnip" },
		{ dir = "@cmp-path@",     name = "cmp-path" },
	},
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')

		luasnip.config.setup {}

		local active = function(filter)
			filter = filter or {}
			filter.direction = filter.direction or 1

			if filter.direction == 1 then
				return luasnip.expand_or_jumpable()
			else
				return luasnip.jumpable(filter.direction)
			end
		end

		local jump = function(direction)
			if direction == 1 then
				if luasnip.expandable() then
					return luasnip.expand_or_jump()
				else
					return luasnip.jumpable(1) and luasnip.jump(1)
				end
			else
				return luasnip.jumpable(-1) and luasnip.jump(-1)
			end
		end

		luasnip.config.set_config {
			history = true,
			updateevents = "TextChanged,TextChangedI",
			override_builtin = true,
		}

		vim.keymap.set({ "i", "s" }, "<c-j>", function()
			return active { direction = 1 } and jump(1)
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<c-k>", function()
			return active { direction = -1 } and jump(-1)
		end, { silent = true })

		vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
		vim.opt.shortmess:append('c')
		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-y>'] = cmp.mapping(
					cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					},
					{ "i", "c" }
				),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'path' },
				{ name = 'buffer' },
				{ name = 'luasnip' },
			},
		}
	end
}
