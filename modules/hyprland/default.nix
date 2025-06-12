{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) listFilesWithNames listNixWithDirs mkEnableOption mkOption remove;

  cfg = config.chonkos.hyprland;
in {
  options.chonkos.hyprland = {
    enable = mkEnableOption "enable hyprland";
    enableMpd = mkEnableOption "enable mpd support";
    enableDebug = mkEnableOption "enable debug logs";
    monitors = mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable (let
    nmEnabled = config.chonkos.network-manager.enable;

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
    programs.hyprland.enable = true;
    hardware = {
      graphics.enable = true;
    };

    programs.light.enable = true;

    environment.systemPackages =
      lib.lists.optional nmEnabled pkgs.networkmanagerapplet
      ++ (with pkgs; [
        libqalculate
        pyprland
        swaylock
        swayidle
      ])
      ++ scripts
      ++ (with pkgs; [
        # Script deps
        acpi
        coreutils
        gawk
        gnused
        grim
        libnotify
        light
        mpc
        pamixer
        pulseaudioFull
        slurp
        wl-clipboard
        zbar
      ])
      ++ lib.lists.optional cfg.enableMpd pkgs.mpd;

    home-manager.sharedModules = [
      # TODO: https://wiki.hyprland.org/Configuring/Window-Rules/ for file picker
      # TODO: try niri
      {
        imports = listNixWithDirs ./. |> remove ./default.nix;

        config = lib.mkIf cfg.enable {
          home.pointerCursor = {
            enable = true;
            package = pkgs.bibata-cursors;
            size = 24;
            name = "Bibata-Original-Classic";

            hyprcursor.enable = true;
            x11.enable = true;
            gtk.enable = true;
          };

          # TODO: Theming
          services.dunst.enable = true;

          wayland.windowManager.hyprland = {
            enable = true;

            systemd.enable = true;

            settings = {
              monitor = cfg.monitors;

              debug.disable_logs = !cfg.enableDebug;

              exec-once = let
                hyprland_before_sleep = pkgs.writeShellScriptBin "hyprland-before-sleep.sh" (with pkgs; ''
                  ${hyprland}/bin/hyprctl switchxkblayout at-translated-set-2-keyboard 0
                  ${playerctl}/bin/playerctl pause -a
                  hyprsetvol -m
                  ${swaylock}/bin/swaylock -f -i ~/.local/share/bg
                '');
              in [
                (lib.optionalString nmEnabled "nm-applet")
                "${pkgs.blueman}/bin/blueman-applet"
                "${pkgs.util-linux}/bin/rfkill block bluetooth"
                # TODO: use home-manager config
                (lib.optionalString cfg.enableMpd "${pkgs/mpd}/bin/mpd")
                "${pkgs.swayidle}/bin/swayidle -w before-sleep ${hyprland_before_sleep}/bin/hyprland-before-sleep.sh"
              ];
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

          home.sessionVariables.NIXOS_OZONE_WL = "1";

          xdg.configFile."hypr/pyprland.toml".source = ./pyprland.toml;
        };
      }
    ];
  });
}
