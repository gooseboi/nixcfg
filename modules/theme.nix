{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.chonkos) isDesktop;

  inherit (lib) mkConst mkIf mkOption types;

  cfg = config.chonkos.theme;
in {
  options.chonkos.theme =
    {
      enable = mkOption {
        type = types.bool;
        description = "enable install of theme packages";
        default = isDesktop;
      };
    }
    // (let
      enableOrThrow = v:
        if cfg.enable
        then v
        else throw "must enable theme installation";

      mkThemeConst = v: mkConst (enableOrThrow v);
    in {
      font.size.normal = mkThemeConst 13;
      font.size.big = mkThemeConst 19;

      font.sans.name = mkThemeConst "Lexend";
      font.sans.package = mkThemeConst pkgs.lexend;

      font.mono.name = mkThemeConst "SauceCodePro Nerd Font Mono";
      font.mono.package = mkThemeConst pkgs.nerd-fonts.sauce-code-pro;

      icons.name = mkThemeConst "Gruvbox-Plus-Dark";
      icons.package = mkThemeConst pkgs.gruvbox-plus-icons;
    })
    // (let
      isValidColor = thing:
        if builtins.isString thing
        then (builtins.match "^[0-9a-fA-F]{6}" thing) != null
        else false;

      mkWith0x = colours:
        builtins.mapAttrs (_: value:
          if isValidColor value
          then "0x" + value
          else value)
        colours;

      mkWithHashtag = colours:
        builtins.mapAttrs (_: value:
          if isValidColor value
          then "#" + value
          else value)
        colours;
    in {
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

      with0x =
        cfg.colours
        |> mkWith0x
        |> mkConst;

      with0xLower =
        cfg.colours
        |> builtins.mapAttrs (
          _: value:
            lib.toLower value
        )
        |> mkWith0x
        |> mkConst;

      withHashtag =
        cfg.colours
        |> mkWithHashtag
        |> mkConst;

      withHashtagLower =
        cfg.colours
        |> builtins.mapAttrs (
          _: value:
            lib.toLower value
        )
        |> mkWithHashtag
        |> mkConst;
    });

  config = mkIf cfg.enable {
    environment.systemPackages = with cfg; [
      font.sans.package
      font.mono.package
      icons.package
    ];
  };
}
