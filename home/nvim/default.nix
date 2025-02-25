{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.chonkos.nvim;
in {
  options.chonkos.nvim = {
    enable = lib.mkEnableOption "enable neovim";
  };

  config = {
    programs.neovim = lib.mkIf cfg.enable {
      enable = true;
      plugins = with pkgs.vimPlugins; [
      ];
      extraPackages = with pkgs; [
        ripgrep
        git
        fd
        nixd
      ];
    };
  };
}
