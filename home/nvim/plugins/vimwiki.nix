{pkgs, ...}: {
  isDesktop = true;

  config = pkgs.replaceVarsWith {
    src = ./configs/vimwiki.lua;
    replacements = with pkgs.vimPlugins; {
      inherit vimwiki;
    };
  };
}
