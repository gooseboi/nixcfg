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
          vista-fonts
          lmodern

          # Joke
          miracode
          monocraft

          # Japanese
          # https://wiki.archlinux.org/title/Localization/Japanese#Fonts
          hanazono
          ipaexfont
          jigmo
          kanji-stroke-order-font
          koruri
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
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
