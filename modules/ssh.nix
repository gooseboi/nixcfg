{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkDisableOption
    mkIf
    ;

  cfg = config.chonkos.openssh;
in {
  options.chonkos.openssh = {
    enable = mkDisableOption "enable openssh server";
  };

  # TODO: YubiKey SSH keys (https://github.com/drduh/YubiKey-Guide)

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
