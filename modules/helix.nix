{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDisableOption mkEnableOption mkIf;

  cfg = config.chonkos.helix;
in {
  options.chonkos.helix = {
    enable = mkEnableOption "enable helix";
    setEnvironment = mkDisableOption "set the EDITOR env variable";
  };

  config = mkIf cfg.enable {
    environment = {
      variables = mkIf cfg.setEnvironment {
        EDITOR = "hx";
      };

      systemPackages = with pkgs; [
        helix
      ];
    };

    home-manager.sharedModules = [
      {
        programs.helix = {
          enable = true;

          settings = {
            theme = "gruvbox_dark_hard";

            editor = {
              auto-completion = false;
              color-modes = true;
              cursorline = true;
              idle-timeout = 0;
              line-number = "relative";
              shell = ["nu" "--commands"];
              text-width = 100;
              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "underline";
              };
            };
          };
        };
      }
    ];
  };
}
