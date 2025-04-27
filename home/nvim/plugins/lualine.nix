{pkgs, ...}: {
  config = pkgs.replaceVarsWith {
    src = ./configs/lualine.lua;
    replacements = with pkgs.vimPlugins; {
      inherit lualine-nvim nvim-web-devicons;
    };
  };
}
