{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkOption
    types
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.nix-ld;
in {
  options.chonkos.nix-ld = {
    enable = mkOption {
      description = "whether to enable nix-ld";
      type = types.bool;
      default = isDesktop;
    };
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
      ];
    };
  };
}
