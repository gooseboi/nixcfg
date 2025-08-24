{pkgs, ...}: {
  config = pkgs.replaceVarsWith {
    src = ./configs/oil.lua;
    replacements = with pkgs.vimPlugins; {
      inherit oil-nvim nvim-web-devicons;
    };
  };
}
