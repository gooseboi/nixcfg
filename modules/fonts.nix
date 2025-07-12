{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.chonkos.fonts;
in {
  options.chonkos.fonts = {
    enable = mkEnableOption "enable font installation";
  };

  config = mkIf cfg.enable {
    chonkos.unfree.allowed = ["corefonts" "vista-fonts"];

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
          lmodern
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
