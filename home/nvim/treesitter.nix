{
  lib,
  pkgs,
  ...
}: let
  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.builtGrammars;
in {
  vim.treesitter = {
    enable = true;
    addDefaultGrammars = true;
    grammars = with treesitterGrammars; [
      # Vim
      vim
      vimdoc
      lua

      # Systems languages
      cpp
      c
      rust
      go
      odin
      zig

      # Buildfiles
      make
      nix

      # Webdev
      typescript
      javascript
      html
      css

      # Typesetting
      markdown
      bibtex
      latex
      typst
    ];

    indent.enable = true;
    highlight.enable = true;
  };
}
