# TODO: https://tonsky.me/blog/syntax-highlighting/
{
  config,
  lib,
  nvf,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkMerge
    ;
  inherit (config.chonkos) isDesktop;

  nvim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
      {
        # I prefer configuring most things in lua, as that is the most portable outside
        # of nix and what is used elsewhere. However, there are things that are
        # somewhat hard to setup outside of nix and those we just do here.
        config.vim = {
          additionalRuntimePaths = [
            ./configs
          ];

          startPlugins = mkMerge (with pkgs.vimPlugins; [
            (mkIf isDesktop [
              blink-cmp
              easymotion
              harpoon2
              nvim-lspconfig
              telescope-fzf-native-nvim
              telescope-nvim
              telescope-ui-select-nvim
              vimwiki
            ])
            [
              comment-nvim
              gruvbox-material
              lualine-nvim
              nvim-web-devicons
              oil-nvim
              plenary-nvim
            ]
          ]);

          extraPackages = mkIf isDesktop (with pkgs; [
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
            vscode-langservers-extracted
            vtsls
            zls
          ]);

          luaConfigPost =
            /*
            lua
            */
            ''
              vim.g.chonkos_desktop = ${
                if isDesktop
                then "true"
                else "false"
              };
              -- Require the manual config we define in lua
              require('luacfg');
            '';

          # Treesitter is installed in nix because I cannot be bothered to
          # figure out how to get treesitter to pick up on all the grammars nix
          # packages (ha) from a path instead of dynamically installing them
          # which is the default behaviour of the plugin).
          treesitter = {
            enable = isDesktop;
            grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;

            context.enable = false;
          };
        };
      }
    ];
  };
in {
  config = {
    environment.systemPackages = [nvim.neovim];
    programs.nvf.enableManpages = true;
  };
}
