{pkgs, ...}: let
  grammarsPath = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
  # These are the ones I'd actually want, but I'll just install all of them for
  # now, cuz it isn't that big really
  # # Vim
  # vim
  # vimdoc
  # lua
  #
  # # Systems languages
  # cpp
  # c
  # rust
  # go
  # odin
  # zig
  #
  # # Buildfiles
  # make
  # nix
  #
  # # Webdev
  # typescript
  # javascript
  # html
  # css
  #
  # # Typesetting
  # markdown
  # bibtex
  # latex
  # typst
in {
  isDesktop = true;

  config = pkgs.replaceVarsWith {
    src = ./configs/treesitter.lua;
    replacements = with pkgs.vimPlugins; {
      inherit nvim-treesitter grammarsPath;
    };
  };
}
