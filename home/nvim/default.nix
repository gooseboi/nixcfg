{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.nvim;
in {
  options.chonkos.nvim = {
    enable = lib.mkEnableOption "enables neovim support";
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.nvf = {
      enable = true;
      settings = {
        imports = [
          ./telescope.nix
        ];
        vim.viAlias = true;
        vim.vimAlias = true;
        vim.extraPackages = with pkgs; [
          ripgrep
          git
          fd
          nixd
        ];
      };
    };
  };
}
