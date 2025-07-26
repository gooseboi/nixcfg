{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.chonkos.devshell;
in {
  options.chonkos.devshell = {
    enable = mkEnableOption "enable devshell install";
    packages = mkOption {
      type = types.listOf types.package;
      description = "list of packages to link globally";
    };
  };

  config = mkIf cfg.enable {
    # The idea from this was mainly from: https://www.reddit.com/r/NixOS/comments/p17r5f/comment/h8jrmns/
    environment = {
      pathsToLink = ["/include"];

      systemPackages = [
        (
          pkgs.writeShellScriptBin "activate_devshell.sh"
          /*
          bash
          */
          ''
            export CPATH="/run/current-system/sw/include";
            export LIBRARY_PATH="/run/current-system/sw/lib";
            export LD_LIBRARY_PATH="${lib.makeLibraryPath cfg.packages}";
          ''
        )
      ];

      shellAliases = {
        activate_devshell = ". activate_devshell.sh";
      };
    };

    chonkos.devshell.packages = with pkgs; [
      stdenv.cc.cc.lib
      gcc
      libz
      libxkbcommon
      vulkan-loader
      wayland
      wayland.dev
    ];
  };
}
