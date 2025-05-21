# TODO: https://wiki.hyprland.org/Configuring/Window-Rules/ for file picker
# TODO: try niri
{
  config,
  lib,
  pkgs,
  systemConfig,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;

  cfg = config.chonkos.hyprland;
  nmEnabled = systemConfig.chonkos.network-manager.enable;

  hyprland_before_sleep = pkgs.writeShellScriptBin "hyprland-before-sleep.sh" (with pkgs; ''
    ${hyprland}/bin/hyprctl switchxkblayout at-translated-set-2-keyboard 0
    ${playerctl}/bin/playerctl pause -a
    hyprsetvol -m
    ${swaylock}/bin/swaylock -f -i ~/.local/share/bg
  '');

  scripts =
    builtins.readDir ./scripts
    |> lib.attrsToList
    |> map (f: f.name)
    |> builtins.map (
      f: ((./scripts
          + "/${f}")
        |> builtins.readFile
        |> pkgs.writeShellScriptBin f)
    );
in {
  imports = [
    ./waybar.nix
  ];

  options.chonkos.hyprland = {
    enable = mkEnableOption "enable hyprland";
    enableMpd = mkEnableOption "enable mpd support";
    enableDebug = mkEnableOption "enable debug logs";
    monitors = mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
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

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      size = 24;
      name = "Bibata-Original-Classic";

      hyprcursor.enable = true;
      x11.enable = true;
      gtk.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;

      systemd.enable = true;

      settings = {
        monitor = cfg.monitors;

        debug.disable_logs = !cfg.enableDebug;

        exec-once = [
          (lib.optionalString nmEnabled "nm-applet")
          "${pkgs.blueman}/bin/blueman-applet"
          "${pkgs.util-linux}/bin/rfkill block bluetooth"
          "${pkgs.dunst}/bin/dunst"
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
