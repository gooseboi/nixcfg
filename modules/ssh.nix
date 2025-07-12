{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.openssh;
in {
  options.chonkos.openssh = {
    enable = mkEnableOption "enable openssh server";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openssh
    ];

    programs.mosh = {
      enable = true;
      openFirewall = true;
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkForce "no";
      };
    };
  };
}
