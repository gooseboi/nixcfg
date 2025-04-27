return {
	dir = "@nvim-treesitter@",
	name = "nvim-treesitter",
	config = function()
		vim.opt.runtimepath:append("@nvim-treesitter@")
		vim.opt.runtimepath:append("@grammarsPath@")
		require('nvim-treesitter.configs').setup {
			auto_install = false,
			sync_install = false,
			ignore_install = {},
			modules = {},

			highlight = { enable = true },
			indent = { enable = true },
		}
	end
}
