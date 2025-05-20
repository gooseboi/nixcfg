{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos;
in {
  options.chonkos.openssh = {
    enable = lib.mkEnableOption "enable openssh server";
  };

  config = lib.mkIf cfg.openssh.enable {
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
