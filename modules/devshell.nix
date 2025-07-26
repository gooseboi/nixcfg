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
    environment = {
      pathsToLink = ["/include"];

      systemPackages = [
        (
          pkgs.writeShellScriptBin "activate_devshell"
          /*
          zsh
          */
          ''
            export CPATH="/run/current-system/sw/include";
            export LIBRARY_PATH="/run/current-system/sw/lib";
            export LD_LIBRARY_PATH="${lib.makeLibraryPath cfg.packages}";
          ''
        )
      ];
    };

    chonkos.devshell.packages = with pkgs; [
      stdenv.cc.cc.lib
      gcc
      libz
      libxkbcommon
      vulkan-loader
      wayland.dev
    ];
  };
}
