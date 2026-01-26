local kset = vim.keymap.set
kset("n", "<C-f>", "<Plug>(easymotion-overwin-w)", { noremap = true, silent = true })
kset("", "<leader>unused", "<Plug>(easymotion-overwin-w)")
