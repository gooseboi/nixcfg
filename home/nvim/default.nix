inputs @ {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.nvim;

  luaFiles = [
    ./lua/config.lua
    ./lua/filetypes.lua
    ./lua/neovide.lua
    ./lua/remap.lua
  ];

  pluginFiles =
    [
      ./comment.nix
      ./easymotion.nix
      ./gruvbox.nix
      ./lualine.nix
      ./oil.nix
    ]
    ++ lib.lists.optionals (! cfg.server) [
      ./cmp.nix
      ./harpoon.nix
      ./lsp.nix
      ./telescope.nix
      ./treesitter.nix
      ./vimwiki.nix
    ];

  pluginContents = builtins.map (f: import f inputs) pluginFiles;
  pluginDeps = lib.lists.flatten (builtins.map (p: p.packages or []) pluginContents);
  pluginSpecs = builtins.concatStringsSep "\n\n" (builtins.map (p: p.config) pluginContents);

  nvim_package = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [lazy-nvim];
    wrapperArgs = with lib; ''--prefix PATH : "${makeBinPath (lists.unique (lists.flatten pluginDeps))}"'';

    luaRcContent =
      /*
      lua
      */
      ''
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
    server = lib.mkEnableOption "marks this neovim install as for a server";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.packages = [
      nvim_package
    ];
  };
}
