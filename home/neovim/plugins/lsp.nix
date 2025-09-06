{pkgs, ...}: {
  isDesktop = true;

  packages = with pkgs; [
    alejandra
    basedpyright
    bash-language-server
    clang-tools
    fenix.rust-analyzer
    gopls
    haskell-language-server
    (
      jdt-language-server.override {
        jdk = pkgs.temurin-bin-21.override {gtkSupport = false;};
      }
    )
    lua-language-server
    nixd
    ols
    tinymist
    vtsls
    zls
  ];

  config = pkgs.replaceVarsWith {
    src = ./configs/lsp.lua;
    replacements = with pkgs.vimPlugins; {
      inherit
        nvim-lspconfig
        # Deps
        telescope-nvim
        blink-cmp
        ;
    };
  };
}
