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

  pluginContents =
    pluginFiles
    |> map (f: import f inputs);
  pluginDeps =
    pluginContents
    |> map (p: p.packages or [])
    |> lib.lists.flatten;
  pluginSpecs =
    pluginContents
    |> map (p: p.config)
    |> builtins.concatStringsSep "\n\n";

  nvim_package = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [lazy-nvim];
    wrapperArgs = with lib; ''--prefix PATH : "${pluginDeps
        |> lists.flatten
        |> lists.unique
        |> makeBinPath}"'';

    luaRcContent =
      /*
      lua
      */
      ''
        ${luaFiles |> map (f: builtins.readFile f) |> builtins.concatStringsSep "\n\n"}

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
