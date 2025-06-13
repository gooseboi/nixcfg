inputs @ {
  config,
  isDesktop,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) filter hasSuffix listFiles makeBinPath mkDisableOption mkEnableOption mkIf mkOption;
  inherit (lib.lists) flatten unique;

  cfg = config.chonkos.nvim;
in {
  options.chonkos.nvim = {
    enable = mkEnableOption "enables neovim support";
    desktopInstall = mkOption {
      description = "makes this neovim install be for a desktop (includes lsp and the like)";
      example = true;
      default = isDesktop;
    };
    setEnvironment = mkDisableOption "set the EDITOR env variable";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = mkIf cfg.setEnvironment {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.packages = let
      luaFiles =
        listFiles ./lua
        |> filter (hasSuffix ".lua");

      pluginContents =
        listFiles ./plugins
        |> filter (hasSuffix ".nix")
        |> map (f: import f inputs)
        |> filter ({isDesktop ? false, ...}: isDesktop -> cfg.desktopInstall)
        |> filter ({enable ? true, ...}: enable);

      pluginDeps =
        pluginContents
        |> map (p: p.packages or [])
        |> flatten
        |> unique;

      pluginSpecs =
        pluginContents
        |> map (p:
          /*
          lua
          */
          ''
            (dofile "${p.config}"),
          '')
        |> builtins.concatStringsSep "\n\n";
    in [
      (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [lazy-nvim];
        wrapperArgs = ''--prefix PATH : "${pluginDeps |> makeBinPath}"'';

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
      })
    ];
  };
}
