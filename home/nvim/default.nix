inputs @ {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) filter hasSuffix listFiles;

  cfg = config.chonkos.nvim;

  luaFiles =
    listFiles ./lua
    |> filter (hasSuffix ".lua");

  pluginContents =
    listFiles ./plugins
    |> filter (hasSuffix ".nix")
    |> map (f: import f inputs)
    |> filter ({isDesktop ? false, ...}: isDesktop -> (! cfg.server));

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
