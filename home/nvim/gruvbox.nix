{
  pkgs,
  lib,
  ...
}: {
  vim.extraPlugins = with pkgs.vimPlugins; {
    gruvbox-material = {
      package = gruvbox-material;
      setup = ''
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_better_performance = 1
        vim.o.background = "dark"
        vim.cmd.colorscheme("gruvbox-material")
      '';
    };
  };
}
