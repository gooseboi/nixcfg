{pkgs, ...}: {
  config = pkgs.replaceVarsWith {
    src = ./configs/gruvbox.lua;
    replacements = with pkgs.vimPlugins; {
      inherit gruvbox-material;
    };
  };
}
