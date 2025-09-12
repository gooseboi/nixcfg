{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    flatten
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

  config = mkIf cfg.enable (let
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
      lists.optional nmEnabled pkgs.networkmanagerapplet
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
      ++ lists.optional cfg.enableMpd pkgs.mpd;

    home-manager.sharedModules = [
      # TODO: https://wiki.hyprland.org/Configuring/Window-Rules/ for file picker
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
                ${hyprland}/bin/hyprctl switchxkblayout at-translated-set-2-keyboard 0
                ${playerctl}/bin/playerctl pause -a
                hyprsetvol -m
                ${swaylock}/bin/swaylock -f -i ~/.local/share/bg
              ''
            ))
          ];

          wayland.windowManager.hyprland = {
            enable = true;

            systemd.enable = true;

            settings = {
              monitor = cfg.monitors;

              debug.disable_logs = !cfg.enableDebug;

              windowrule = let
                fileChooser = selector: [
                  "float, ${selector}"
                  "size 50% 90%, ${selector}"
                  "center, ${selector}"
                ];
              in
                [
                  # Librewolf file picker
                  (fileChooser "class:^(librewolf)$, title:^(Open File|Save As)$")
                  # Cursor file picker
                  (fileChooser "class:^(cursor)$, title:^(Open Folder|Open File)$")
                ]
                |> flatten;

              exec-once = [
                (optionalString nmEnabled "nm-applet")
                "${pkgs.blueman}/bin/blueman-applet"
                "${pkgs.util-linux}/bin/rfkill block bluetooth"
                # TODO: use home-manager config
                (optionalString cfg.enableMpd "${pkgs/mpd}/bin/mpd")
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
