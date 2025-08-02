{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) filter mkEnableOption mkIf mkOption types;
  inherit (lib.strings) concatStringsSep;

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
          pkgs.writeShellScriptBin "activate_devshell.sh" (
            let
              makeSearchPath = packages: subDir: sep:
                packages
                |> filter (p: p != null)
                |> map (p: "${p}/${subDir}")
                |> filter builtins.pathExists
                |> concatStringsSep sep;

              libraryPath = makeSearchPath cfg.packages "lib" ":";

              cPath = makeSearchPath cfg.packages "include" ":";

              pkgConfigPath = makeSearchPath cfg.packages "lib/pkgconfig" ":";
            in
              /*
              bash
              */
              ''
                export CPATH="${cPath}";
                export LIBRARY_PATH="${libraryPath}";
                export LD_LIBRARY_PATH="${libraryPath}";
                export PKG_CONFIG_PATH="${pkgConfigPath}";
              ''
          )
        )
        pkgs.pkg-config
      ];

      shellAliases = {
        activate_devshell = ". activate_devshell.sh";
      };
    };

    chonkos.devshell.packages = with pkgs; [
      atk
      atk.dev
      cairo
      cairo.dev
      gcc
      gdk-pixbuf
      gdk-pixbuf.dev
      glib.out
      glib.dev
      gtk3
      gtk3.dev
      harfbuzz
      harfbuzz.dev
      libsoup_3
      libsoup_3.dev
      libxkbcommon
      libxkbcommon.dev
      libz
      libz.dev
      pango.out
      pango.dev
      stdenv.cc.cc.lib
      vulkan-loader
      wayland
      wayland.dev
      webkitgtk_4_1
      webkitgtk_4_1.dev
      webkitgtk_6_0
      webkitgtk_6_0.dev
      zlib
      zlib.dev
    ];
  };
}
