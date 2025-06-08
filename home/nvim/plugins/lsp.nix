{pkgs, ...}: {
  isDesktop = true;

  packages = with pkgs; [
    alejandra
    bash-language-server
    clang-tools
    fenix.rust-analyzer
    gopls
    haskell-language-server
    jdt-language-server
    lua-language-server
    nixd
    ols
    python3.pkgs.python-lsp-server
    tinymist
    typescript-language-server
    zls
  ];

  config = pkgs.replaceVarsWith {
    src = ./configs/lsp.lua;
    replacements = with pkgs.vimPlugins; {
      inherit
        nvim-lspconfig
        # Deps
        neodev-nvim
        telescope-nvim
        blink-cmp
        ;
    };
  };
}
