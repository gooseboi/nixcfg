{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.chonkos.fonts;
in {
  options.chonkos.fonts = {
    enable = lib.mkEnableOption "enable font installation";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      fontconfig.enable = true;
    };
    home.packages = with pkgs;
      [
        libertinus
        noto-fonts
        noto-fonts-color-emoji
        jetbrains-mono
        iosevka
        corefonts
        vistafonts
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues nerd-fonts);
  };
}
