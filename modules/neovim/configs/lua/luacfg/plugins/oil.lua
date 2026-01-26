CustomOilBar = function()
	local path = vim.fn.expand "%"
	path = path:gsub("oil://", "")

	return "  " .. vim.fn.fnamemodify(path, ":.")
end

require("oil").setup {
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = { "icon" },
	keymaps = {
		["<C-h>"] = false,
		["<C-l>"] = false,
		["<C-k>"] = false,
		["<C-j>"] = false,
		["<M-h>"] = "actions.select_split",
	},
	win_options = {
		winbar = "%{v:lua.CustomOilBar()}",
	},
	view_options = {
		show_hidden = true,
	},
}

-- Open parent directory in current window
vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
