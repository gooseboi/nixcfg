{pkgs, ...}: {
  isDesktop = true;

  config = pkgs.replaceVarsWith {
    src = ./configs/harpoon.lua;
    replacements = with pkgs.vimPlugins; {
      inherit harpoon plenary-nvim;
    };
  };
}
