{pkgs, ...}: {
  config = pkgs.replaceVarsWith {
    src = ./configs/easymotion.lua;
    replacements = with pkgs.vimPlugins; {
      inherit easymotion;
    };
  };
}
