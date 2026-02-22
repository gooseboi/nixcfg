{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    attrValues
    filter
    getExe
    getExe'
    listFilesWithNames
    listNixWithDirs
    listToAttrs
    lists
    mkEnableOption
    mkForce
    mkIf
    mkOption
    optionalString
    remove
    minsToSecs
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
      }: {
        inherit name;
        value = pkgs.writeShellApplication {
          inherit name;
          text = builtins.readFile path;
          runtimeInputs = with pkgs; [
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
          ];
          bashOptions = [];
        };
      }
    )
    |> listToAttrs;

  before-sleep = pkgs.writeShellScriptBin "hyprland-before-sleep.sh" ''
    ${getExe' pkgs.hyprland "hyprctl"} switchxkblayout at-translated-set-2-keyboard 0
    ${getExe' pkgs.hyprland "hyprctl"} dispatch dpms on
    ${getExe pkgs.playerctl} pause -a
    ${getExe scripts.hyprsetvol} -m
    ${getExe pkgs.swaylock} -f -i ~/.local/share/bg
  '';
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
        hypr-zoom
      ])
      ++ (attrValues scripts)
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

          wayland.windowManager.hyprland = {
            enable = true;

            systemd.enable = true;

            settings = {
              monitor = cfg.monitors;

              debug.disable_logs = !cfg.enableDebug;

              exec-once =
                [
                  (getExe' pkgs.blueman "blueman-applet")
                  "${getExe' pkgs.util-linux "rfkill"}rblock bluetooth"
                  # TODO: use home-manager config
                  (optionalString cfg.enableMpd "${getExe pkgs.mpd}")
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
            tailray.enable = tailscaleEnabled;
            swayidle = {
              enable = true;
              events = {
                "before-sleep" = getExe before-sleep;
              };
              timeouts = [
                {
                  timeout = minsToSecs 5;
                  command = "${getExe' pkgs.hyprland "hyprctl"} dispatch dpms off";
                  resumeCommand = "${getExe' pkgs.hyprland "hyprctl"} dispatch dpms on";
                }
                {
                  timeout = minsToSecs 15;
                  command = getExe before-sleep;
                }
              ];
            };
          };

          systemd.user.services.tailray = {
            # This is to set "graphical-session.target" instead of
            # "graphical-session-pre.target" Why exactly this is necessary is
            # beyond me, but it fixes the problem. The reason I set it to be
            # this is because network-manager-applet has it done like this.
            Unit.After = mkForce ["graphical-session.target" "tray.target"];
          };

          home.sessionVariables.NIXOS_OZONE_WL = "1";
        };
      }
    ];
  };
}
