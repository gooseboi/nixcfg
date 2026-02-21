{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    filter
    getExe
    listFilesWithNames
    listNixWithDirs
    lists
    mkEnableOption
    mkIf
    mkOption
    optionalString
    remove
    types
    ;

  cfg = config.chonkos.hyprland;

  networkManagerEnabled = config.chonkos.network-manager.enable;
  tailscaleEnabled = config.chonkos.tailscale.enable;

  scripts =
    listFilesWithNames ./scripts
    |> map (
      {
        name,
        path,
      }:
        pkgs.writeShellScriptBin name (builtins.readFile path)
    );
in {
  options.chonkos.hyprland = {
    enable = mkEnableOption "enable hyprland";
    enableMpd = mkEnableOption "enable mpd support";
    enableDebug = mkEnableOption "enable debug logs";
    monitors = mkOption {
      type = types.listOf types.str;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    hardware = {
      graphics.enable = true;
    };

    programs.light.enable = true;

    environment.systemPackages =
      (with pkgs; [
        libqalculate
      ])
      ++ scripts
      ++ (with pkgs; [
        # Script deps
        acpi
        coreutils
        gawk
        gnused
        grim
        hypr-zoom
        libnotify
        light
        mpc
        pamixer
        pulseaudioFull
        slurp
        wl-clipboard
        zbar
      ])
      ++ lists.optional cfg.enableMpd pkgs.mpd;

    home-manager.sharedModules = [
      # TODO: try niri
      {
        imports = listNixWithDirs ./. |> remove ./default.nix;

        config = mkIf cfg.enable {
          home.pointerCursor = {
            enable = true;
            package = pkgs.bibata-cursors;
            size = 24;
            name = "Bibata-Original-Classic";

            dotIcons.enable = false;
            hyprcursor.enable = true;
            x11.enable = true;
            gtk.enable = true;
          };

          home.packages = [
            (pkgs.writeShellScriptBin "hyprland-before-sleep.sh" (
              with pkgs; ''
                ${getExe hyprland} switchxkblayout at-translated-set-2-keyboard 0
                ${getExe playerctl} pause -a
                hyprsetvol -m
                ${getExe swaylock} -f -i ~/.local/share/bg
              ''
            ))
            (pkgs.writeShellScriptBin "hyprland-swayidle.sh" (
              with pkgs; ''
                ${getExe swayidle} -w \
                  before-sleep hyprland-before-sleep.sh \
                  timeout 300 'hyprctl dispatch dpms off' \
                  resume 'hyprctl dispatch dpms on'
              ''
            ))
          ];

          wayland.windowManager.hyprland = {
            enable = true;

            systemd.enable = true;

            settings = {
              monitor = cfg.monitors;

              debug.disable_logs = !cfg.enableDebug;

              exec-once =
                [
                  "${pkgs.blueman}/bin/blueman-applet"
                  "${pkgs.util-linux}/bin/rfkill block bluetooth"
                  # TODO: use home-manager config
                  (optionalString cfg.enableMpd "${pkgs/mpd}/bin/mpd")
                ]
                |> filter (s: s != "");
            };

            extraConfig = builtins.readFile ./hyprland.conf;
          };

          xdg.portal = {
            enable = true;
            config.common.default = "*";

            configPackages = [
              pkgs.hyprland
            ];

            extraPortals = [
              pkgs.xdg-desktop-portal-hyprland
            ];
          };

          services = {
            hyprpolkitagent.enable = true;
            network-manager-applet.enable = networkManagerEnabled;
            # FIXME: This doesn't work because:
            # ''
            # Found ordering cycle:
            # tailray.service/start after
            # tray.target/start after
            # waybar.service/start after
            # graphical-session.target/start -
            # after tailray.service
            # ''
            # however, the service file for nm-applet works fine, and it's
            # mostly the same. The difference is it's
            # After=graphical-session.target instead of
            # graphical-session-pre.target, maybe that's the problem, but I
            # don't know how to remove the value and then add the new one.
            tailray.enable = tailscaleEnabled;
          };

          home.sessionVariables.NIXOS_OZONE_WL = "1";
        };
      }
    ];
  };
}
