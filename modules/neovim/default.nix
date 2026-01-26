# TODO: https://tonsky.me/blog/syntax-highlighting/
{
  pkgs,
  nvf,
  ...
}: let
  nvim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
      {
        # I prefer configuring most things in lua, as that is the most portable outside
        # of nix and what is used elsewhere. However, there are things that are
        # somewhat hard to setup outside of nix and those we just do here.
        config.vim = {
          additionalRuntimePaths = [
            "~/.config/nvim"
          ];

          # TODO: Some of these shouldn't go on servers
          startPlugins = with pkgs.vimPlugins; [
            comment-nvim
            blink-cmp
            easymotion
            gruvbox-material
            harpoon2
            lualine-nvim
            nvim-lspconfig
            nvim-web-devicons
            oil-nvim
            plenary-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            telescope-ui-select-nvim
            vimwiki
          ];

          extraPackages = with pkgs; [
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
          ];

          luaConfigPost =
            /*
            lua
            */
            ''
              -- Require the manual config we define in lua
              require('luacfg');
            '';

          # Treesitter is installed in nix because I cannot be bothered to
          # figure out how to get treesitter to pick up on all the grammars nix
          # packages (ha) from a path instead of dynamically installing them
          # which is the default behaviour of the plugin).
          treesitter = {
            enable = true;
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
    home-manager.sharedModules = [
      {
        xdg.configFile."nvim" = {
          source = ./configs;
          recursive = true;
        };
      }
    ];
  };
}
