{
  pkgs,
  lib,
  ...
}: {
  vim.extraPlugins = with pkgs.vimPlugins; {
    easymotion = {
      package = easymotion;
      setup = ''
        local kset = vim.keymap.set
        kset("n", "<C-f>", "<Plug>(easymotion-overwin-w)", { noremap = true, silent = true })
        kset("", "<leader>unused", "<Plug>(easymotion-overwin-w)")
        kset("", "<C-f>", "<Plug>(easymotion-overwin-w)", { noremap = true, silent = true })
      '';
    };
  };
}
