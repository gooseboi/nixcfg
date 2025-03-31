{pkgs, ...}: let
  p = pkgs.vimPlugins;
  grammarsPath = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = p.nvim-treesitter.withAllGrammars.dependencies;
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
  config =
    /*
    lua
    */
    ''
      {
        dir = "${p.nvim-treesitter}",
        name = "nvim-treesitter",
        config = function()
          vim.opt.runtimepath:append("${p.nvim-treesitter}")
          vim.opt.runtimepath:append("${grammarsPath}")
          require ('nvim-treesitter.configs').setup {
            auto_install = false,
            sync_install = false,
            ignore_install = {},
            modules = {},

            highlight = { enable = true },
            indent = { enable = true },
          }
        end
      },
    '';
}
