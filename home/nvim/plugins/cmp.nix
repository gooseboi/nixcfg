{pkgs, ...}: {
  isDesktop = true;

  config = pkgs.replaceVarsWith {
    src = ./configs/cmp.lua;
    replacements = with pkgs.vimPlugins; {
      inherit
        nvim-cmp
        # Deps
        cmp-nvim-lsp
        luasnip
        cmp_luasnip
        cmp-path
        ;
    };
  };
}
