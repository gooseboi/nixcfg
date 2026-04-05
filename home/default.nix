{
  config,
  lib,
  ...
}: let
  inherit (lib) listNixWithDirs mkOption remove types;

  cfg = config.chonkos;
in {
  imports = listNixWithDirs ./. |> remove ./default.nix;

  options.chonkos = {
    user = mkOption {
      type = types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };
  };

  config = {
    home = {
      username = cfg.user;
      homeDirectory = "/home/${cfg.user}";
    };

    home.sessionVariables =
      # Default Apps
      {
        COLORTERM = "truecolor";
        OPENER = "xdg-open";
      };
  };
}
