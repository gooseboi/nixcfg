{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkConst mkDisableOption;

  cfg = config.chonkos.theme;
in {
  options.chonkos.theme = {
    enable = mkDisableOption "enable automatic install of theme packages";

    font.size.normal = mkConst 13;
    font.size.big = mkConst 19;

    font.sans.name = mkConst "Lexend";
    font.sans.package = mkConst pkgs.lexend;

    font.mono.name = mkConst "SauceCodePro Nerd Font Mono";
    font.mono.package = mkConst pkgs.nerd-fonts.sauce-code-pro;

    icons.name = mkConst "Gruvbox-Plus-Dark";
    icons.package = mkConst pkgs.gruvbox-plus-icons;
  };

  config = {
    environment.systemPackages = with cfg; [
      font.sans.package
      font.mono.package
      icons.package
    ];
  };
}
