{
  config,
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkBoolOption
    mkDisableOption
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.deploy;
in {
  options.chonkos.deploy = {
    enable = mkEnableOption "enable registering this device as deployable";

    remoteBuild = mkEnableOption "build the config on remote instead of local";
    sshUser = mkOption {
      type = types.str;
      default = config.chonkos.user;
      description = "user to run ssh as";
    };
    user = mkOption {
      type = types.str;
      default = config.chonkos.user;
      description = "user to deploy to";
    };
    # TODO: No interactive sudo (a `deploy` user with /bin/nologin?)
    interactiveSudo = mkDisableOption "run sudo interactively";

    install = mkBoolOption "enable installing the deploy-rs package" isDesktop;
  };

  config = {
    environment.systemPackages = mkIf cfg.install [
      # TODO: Is there a nicer way to reference this?
      inputs.deploy-rs.packages.${config.nixpkgs.hostPlatform.system}.deploy-rs
    ];
  };
}
