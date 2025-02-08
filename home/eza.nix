{
  pkgs,
  lib,
  config,
  ...
}: {
  options.chonkos.eza = {
    enable = lib.mkEnableOption "enable eza";
    enableZshIntegration = lib.mkOption {
      default = config.chonkos.zsh.enable;
      defaultText = "enable zsh integration";
      example = false;
    };
  };

  config.programs.eza = lib.mkIf config.chonkos.eza.enable {
    enable = true;
    enableZshIntegration = config.chonkos.eza.enableZshIntegration;
  };
}
