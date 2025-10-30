return
{
	dir = "@telescope-nvim@",
	name = "telescope-nvim",
	dependencies = {
		{ dir = "@plenary-nvim@",              name = "plenary", },
		{ dir = "@telescope-fzf-native-nvim@", name = "telescope-fzf-native-nvim", },
	},
	config = function()
		local telescope = require("telescope")
		telescope.load_extension('fzf')
		local actions = require("telescope.actions")

		-- Telescope setup
		telescope.setup({
			defaults = {
				prompt_prefix = '> ',
				selection_caret = ' ',
				path_display = { truncate = 1 },
				preview = {
					msg_bg_fillchar = "#",
				},
				-- Mappings inside of the telescope prompt
				mappings = {
					i = {
						-- Movement
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						-- History
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						-- Ctrl-s to open a horizontal split
						["<C-s>"] = actions.select_horizontal,
						-- Ctrl-v to open a vertical split
						["<C-v>"] = actions.select_vertical,

					},
					n = {
						-- Ctrl-s to open a horizontal split
						["<C-s>"] = actions.select_horizontal,
						-- Ctrl-v to open a vertical split
						["<C-v>"] = actions.select_vertical,
					},
				},
			},
			extensions = {
				fzf = {
					-- false will only do exact matching
					fuzzy = true,
					-- override the generic sorter
					override_generic_sorter = true,
					-- override the file sorter
					override_file_sorter = true,
					-- or "ignore_case" or "respect_case"
					case_mode = "smart_case",
				}
			},
		})

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>pf', builtin.git_files, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>gs', builtin.live_grep, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>;', builtin.buffers, { noremap = true, silent = true })
	end
}
