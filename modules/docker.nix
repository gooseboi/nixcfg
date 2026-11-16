{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    attrsets
    mkEnableOption
    mkIf
    ;

  cfg = config.chonkos.docker;
  package = pkgs.docker.override (
    {
      buildxSupport = true;
      composeSupport = true;
    }
    // (
      attrsets.optionalAttrs config.chonkos.git.enable {
        gitMinimal = config.chonkos.git.package;
      }
    )
  );
in {
  options.chonkos.docker = {
    enable = mkEnableOption "enable docker";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = false;
        inherit package;

        storageDriver = "btrfs";
        enableOnBoot = false;

        rootless = {
          enable = true;
          inherit package;

          setSocketVariable = true;
        };
      };
    };

    environment.shellAliases.docc = "docker compose";

    environment.systemPackages = with pkgs; [
      dive
    ];
  };
}
