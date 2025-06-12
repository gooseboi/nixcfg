{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkConst mkDisableOption;

  cfg = config.chonkos.theme;
in {
  options.chonkos.theme =
    {
      enable = mkDisableOption "enable automatic install of theme packages";
    }
    // {
      font.size.normal = mkConst 13;
      font.size.big = mkConst 19;

      font.sans.name = mkConst "Lexend";
      font.sans.package = mkConst pkgs.lexend;

      font.mono.name = mkConst "SauceCodePro Nerd Font Mono";
      font.mono.package = mkConst pkgs.nerd-fonts.sauce-code-pro;

      icons.name = mkConst "Gruvbox-Plus-Dark";
      icons.package = mkConst pkgs.gruvbox-plus-icons;

      # name = "Gruvbox dark hard";
      # author = "Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)";
      # Taken from https://github.com/RGBCube/ThemeNix/blob/1267b9132b3a9c1d6e5c92f52ea1ca780ab2ac4f/themes/gruvbox-dark-hard.nix
      colours = mkConst {
        base00 = "1D2021";
        base01 = "3C3836";
        base02 = "504945";
        base03 = "665C54";
        base04 = "BDAE93";
        base05 = "D5C4A1";
        base06 = "EBDBB2";
        base07 = "FBF1C7";
        base08 = "FB4934";
        base09 = "FE8019";
        base0A = "FABD2F";
        base0B = "B8BB26";
        base0C = "8EC07C";
        base0D = "83A598";
        base0E = "D3869B";
        base0F = "D65D0E";
      };
    }
    // (let
      isValidColor = thing:
        if builtins.isString thing
        then (builtins.match "^[0-9a-fA-F]{6}" thing) != null
        else false;
    in {
      with0x =
        builtins.mapAttrs (_: value:
          if isValidColor value
          then "0x" + value
          else value)
        cfg.colours
        |> mkConst;

      withHashtag =
        builtins.mapAttrs (_: value:
          if isValidColor value
          then "#" + value
          else value)
        cfg.colours
        |> mkConst;
    });

  config = {
    environment.systemPackages = with cfg; [
      font.sans.package
      font.mono.package
      icons.package
    ];
  };
}
