{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.chonkos;
in {
  options.chonkos.zsh = {
    enable = lib.mkEnableOption "enable system-wide zsh support";
  };
  config = lib.mkIf cfg.zsh.enable {
    programs.zsh.enable = true;
    environment.pathsToLink = ["/share/zsh"];
    users.users.${cfg.user}.shell = pkgs.zsh;
  };
}
