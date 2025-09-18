{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) filter flatten mkEnableOption mkIf mkOption optional types;
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

  config = let
    makeSearchPath = packages: subDir: sep:
      packages
      |> filter (p: p != null)
      |> map (p: "${p}/${subDir}")
      |> filter builtins.pathExists
      |> concatStringsSep sep;

    withDevAndOut = packages:
      packages
      |> map (p: [p.out] ++ (optional (p ? dev) p.dev))
      |> flatten;

    packages = withDevAndOut cfg.packages;

    libraryPath = makeSearchPath packages "lib" ":";

    cPath = makeSearchPath packages "include" ":";

    pkgConfigPath = makeSearchPath packages "lib/pkgconfig" ":";
    pkgConfigPath' = makeSearchPath packages "share/pkgconfig" ":";

    activationText =
      /*
      bash
      */
      ''
        export CPATH="$CPATH:${cPath}";
        export LIBRARY_PATH="$LIBRARY_PATH:${libraryPath}";
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libraryPath}";
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgConfigPath}:${pkgConfigPath'}";
      '';
  in
    mkIf cfg.enable {
      # The idea from this was mainly from: https://www.reddit.com/r/NixOS/comments/p17r5f/comment/h8jrmns/
      environment = {
        systemPackages = [
          (pkgs.writeShellScriptBin "devsh_activate"
            /*
            bash
            */
            ''
              ${activationText}
              $SHELL
            '')
          (pkgs.writeShellScriptBin "devsh_run"
            /*
            bash
            */
            ''
              ${activationText}
              $@
            '')
          pkgs.pkg-config
        ];
      };

      chonkos.devshell.packages = with pkgs; [
        atk
        cairo
        dbus
        ffmpeg-full
        gcc
        gdk-pixbuf
        glfw2
        glfw3
        glib
        graphene
        gtk3
        gtk3
        gtk4
        gtk4-layer-shell
        harfbuzz
        libadwaita
        libcap
        libdrm
        libglvnd
        libpulseaudio
        libsoup_3
        libva
        libxkbcommon
        libxml2
        libxslt
        libz
        openssl
        pango
        pipewire
        raylib
        sdl3
        stdenv.cc.cc.lib
        systemdLibs
        vulkan-headers
        vulkan-loader
        wayland
        wayland-scanner
        webkitgtk_4_1
        webkitgtk_6_0
        xdotool
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.xorgproto
        zlib
      ];
    };
}
