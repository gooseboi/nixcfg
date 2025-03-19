inputs @ {
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.nvim;

  luaFiles = [
    ./lua/config.lua
    ./lua/filetypes.lua
    ./lua/neovide.lua
    ./lua/remap.lua
  ];

  pluginFiles = [
    ./cmp.nix
    ./comment.nix
    ./easymotion.nix
    ./gruvbox.nix
    ./harpoon.nix
    ./lsp.nix
    ./lualine.nix
    ./oil.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  pluginContents = builtins.map (f: import f inputs) pluginFiles;
  pluginDeps = lib.lists.flatten (builtins.map (p: p.packages or []) pluginContents);
  pluginSpecs = builtins.concatStringsSep "\n\n" (builtins.map (p: p.config) pluginContents);

  nvim_package = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [lazy-nvim];
    wrapperArgs = with lib; ''--prefix PATH : "${makeBinPath (lists.unique (lists.flatten pluginDeps))}"'';

    luaRcContent = ''
      ${builtins.concatStringsSep "\n\n" (builtins.map (f: builtins.readFile f) luaFiles)}

      require("lazy").setup({
      	spec = {
          ${pluginSpecs}
      	},
        rocks = { enabled = false },
        pkg = { enabled = false },
        install = { missing = false },
        change_detection = { enabled = false },
      })
    '';
  };
in {
  options.chonkos.nvim = {
    enable = lib.mkEnableOption "enables neovim support";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
    };

    home-manager.sharedModules = [
      {
        home.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };

        home.packages = [nvim_package];
      }
    ];
  };
}
