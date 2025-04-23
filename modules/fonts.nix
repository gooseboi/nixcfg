{
  config,
  lib,
  pkgs,
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
      packages =
        (with pkgs; [
          libertinus
          noto-fonts
          noto-fonts-color-emoji
          jetbrains-mono
          iosevka
          corefonts
          vistafonts
        ])
        ++ (pkgs.nerd-fonts
          |> builtins.attrValues
          |> builtins.filter lib.attrsets.isDerivation);
    };
    environment.systemPackages = with pkgs; [
      font-manager
    ];
  };
}
