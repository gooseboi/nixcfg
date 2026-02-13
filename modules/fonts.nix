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
          corefonts
          et-book
          googlesans-code
          intel-one-mono
          iosevka
          jetbrains-mono
          libertinus
          lmodern
          noto-fonts
          noto-fonts-color-emoji
          vista-fonts

          # Joke
          minecraftia
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
