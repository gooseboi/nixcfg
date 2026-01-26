-- Don't map anything thank you (https://github.com/easymotion/vim-easymotion/blob/master/plugin/EasyMotion.vim#L237)
vim.g.EasyMotion_do_mapping = 0

local kset = vim.keymap.set
kset("n", "<C-f>", "<Plug>(easymotion-overwin-w)", { noremap = true, silent = true })
kset("", "<leader>unused", "<Plug>(easymotion-overwin-w)")
