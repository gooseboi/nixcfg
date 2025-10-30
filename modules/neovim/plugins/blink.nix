{pkgs, ...}: {
  isDesktop = true;

  config = pkgs.replaceVarsWith {
    src = ./configs/blink.lua;
    replacements = with pkgs.vimPlugins; {
      inherit
        blink-cmp
        ;
    };
  };
}
