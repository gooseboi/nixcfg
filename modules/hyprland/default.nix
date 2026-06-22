{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    attrValues
    getExe
    getExe'
    listFilesWithNames
    listNixWithDirs
    listToAttrs
    lists
    mkEnableOption
    mkIf
    mkOption
    remove
    minsToSecs
    types
    ;

  inherit
    (lib.strings)
    escapeShellArg
    ;

  inherit
    (lib.generators)
    mkLuaInline
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
            wireplumber
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
  imports = listNixWithDirs ./. |> remove ./default.nix;

  options.chonkos.hyprland = {
    enable = mkEnableOption "enable hyprland";
    enableMpd = mkEnableOption "enable mpd support";
    enableDebug = mkEnableOption "enable debug logs";
    monitors = mkOption {
      description = "monitor config";
      readOnly = true;
      type = types.listOf <| types.submodule {freeformType = types.attrsOf types.anything;};
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
        # TODO: Autolaunch blueman applet
        config = mkIf cfg.enable {
          wayland.windowManager.hyprland = {
            enable = true;

            systemd.enable = true;

            configType = "lua";

            settings = {
              config = {
                debug.disable_logs = !cfg.enableDebug;
              };

              monitor = cfg.monitors;

              # exec-once =
              #   [
              #     (optionalString cfg.enableMpd "${getExe pkgs.mpd}")
              #   ]
              #   |> filter (s: s != "");
              #

              bind = [
                {
                  _args = [
                    "SUPER + SHIFT + E"
                    (mkLuaInline ''hl.dsp.exec_cmd("${getExe lock}")'')
                  ];
                }
              ];
            };

            extraConfig = builtins.readFile ./hyprland.lua;
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
            hypridle = {
              enable = true;

              settings = {
                general = {
                  before_sleep_cmd = getExe before-sleep;
                };

                listener = [
                  {
                    timeout = minsToSecs 5;
                    on-timeout = "${getExe' pkgs.hyprland "hyprctl"} dispatch ${escapeShellArg ''hl.dsp.dpms({action="off"})''}";
                    on-resume = "${getExe' pkgs.hyprland "hyprctl"} dispatch ${escapeShellArg ''hl.dsp.dpms({action="on"})''}";
                  }
                  {
                    timeout = minsToSecs 15;
                    on-timeout = getExe lock;
                  }
                ];
              };
            };
            hyprpaper = {
              enable = true;
              settings = {
                wallpaper = [
                  {
                    monitor = "";
                    path = "~/.local/share/bg";
                    fit_mode = "stretch";
                  }
                ];
              };
            };
          };

          home.sessionVariables.NIXOS_OZONE_WL = "1";
        };
      }
    ];
  };
}
