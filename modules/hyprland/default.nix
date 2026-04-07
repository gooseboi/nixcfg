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
    mkIf
    mkOption
    optionalString
    remove
    minsToSecs
    types
    ;

  cfg = config.chonkos.hyprland;

  networkManagerEnabled = config.chonkos.network-manager.enable;

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

  lock = pkgs.writeShellScriptBin "hyprland-before-lock.sh" ''
    ${getExe' pkgs.hyprland "hyprctl"} switchxkblayout at-translated-set-2-keyboard 0
    ${getExe pkgs.playerctl} pause -a
    ${getExe scripts.hyprsetvol} -m
    ${getExe pkgs.swaylock} -f -i ~/.local/share/bg
    ${getExe' pkgs.dunst "dunstctl"} set-paused false
  '';
  before-sleep = pkgs.writeShellScriptBin "hyprland-before-sleep.sh" ''
    ${getExe' pkgs.hyprland "hyprctl"} dispatch dpms on
    ${getExe lock}
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

    environment.systemPackages =
      (with pkgs; [
        brightnessctl
        hypr-zoom
        libqalculate
      ])
      ++ (attrValues scripts)
      ++ lists.optional cfg.enableMpd pkgs.mpd;

    home-manager.sharedModules = [
      # TODO: try niri
      {
        imports = listNixWithDirs ./. |> remove ./default.nix;

        config = mkIf cfg.enable {
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

              bind = [
                "SUPERSHIFT, E, exec, ${getExe lock}"
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

          services = {
            hyprpolkitagent.enable = true;
            network-manager-applet.enable = networkManagerEnabled;
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
                  command = getExe lock;
                }
              ];
            };
          };

          home.sessionVariables.NIXOS_OZONE_WL = "1";
        };
      }
    ];
  };
}
