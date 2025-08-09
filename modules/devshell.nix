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
              pkgConfigPath' = makeSearchPath cfg.packages "share/pkgconfig" ":";
            in
              /*
              bash
              */
              ''
                export CPATH="${cPath}";
                export LIBRARY_PATH="${libraryPath}";
                export LD_LIBRARY_PATH="${libraryPath}";
                export PKG_CONFIG_PATH="${pkgConfigPath}:${pkgConfigPath'}";
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
      dbus
      dbus.dev
      ffmpeg-full.dev
      ffmpeg-full.out
      gcc
      gdk-pixbuf
      gdk-pixbuf.dev
      glfw2
      glfw3
      glib.dev
      glib.out
      graphene.dev
      graphene.out
      gtk3
      gtk3.dev
      gtk3.dev
      gtk3.out
      gtk4-layer-shell.dev
      gtk4-layer-shell.out
      gtk4.dev
      gtk4.out
      harfbuzz
      harfbuzz.dev
      libadwaita.dev
      libadwaita.out
      libcap
      libcap.dev
      libdrm.dev
      libdrm.out
      libpulseaudio
      libpulseaudio.dev
      libsoup_3
      libsoup_3.dev
      libva
      libva.dev
      libxkbcommon
      libxkbcommon.dev
      libxml2
      libxml2.dev
      libxslt.dev
      libz
      libz.dev
      pango.dev
      pango.out
      pipewire.dev
      pipewire.out
      raylib
      sdl3
      sdl3.dev
      stdenv.cc.cc.lib
      vulkan-headers
      vulkan-loader.dev
      vulkan-loader.out
      wayland-scanner.dev
      wayland-scanner.out
      wayland.dev
      wayland.out
      webkitgtk_4_1
      webkitgtk_4_1.dev
      webkitgtk_6_0
      webkitgtk_6_0.dev
      xorg.libX11.dev
      xorg.libX11.out
      xorg.libXcomposite.dev
      xorg.libXcomposite.out
      xorg.libXdamage.dev
      xorg.libXdamage.out
      xorg.libXfixes.dev
      xorg.libXfixes.out
      xorg.libXi.dev
      xorg.libXi.out
      xorg.libXrandr.dev
      xorg.libXrandr.out
      xorg.libXrender.dev
      xorg.libXrender.out
      xorg.xorgproto
      zlib
      zlib.dev
    ];
  };
}
