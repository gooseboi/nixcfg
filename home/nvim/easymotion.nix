{
  pkgs,
  lib,
  ...
}: {
  home.file.".config/nvim/lua/chonk/plugins/easymotion.lua".text = with pkgs.vimPlugins; ''
    return {
      dir = "${easymotion}",
      name = easymotion,
      config = function()
        local kset = vim.keymap.set
        kset("n", "<C-f>", "<Plug>(easymotion-overwin-w)", { noremap = true, silent = true })
        kset("", "<leader>unused", "<Plug>(easymotion-overwin-w)")
        kset("", "<C-f>", "<Plug>(easymotion-overwin-w)", { noremap = true, silent = true })
      end
    }
  '';
}
