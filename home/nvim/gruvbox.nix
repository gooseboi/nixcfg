{
  pkgs,
  lib,
  ...
}: {
  home.file.".config/nvim/lua/chonk/plugins/gruvbox.lua".text = with pkgs.vimPlugins; ''
    return {
      dir = "${gruvbox-material}",
      name = "gruvbox-material",
      config = function()
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_better_performance = 1
        vim.o.background = "dark"
        vim.cmd.colorscheme("gruvbox-material")
      end
    }
  '';
}
