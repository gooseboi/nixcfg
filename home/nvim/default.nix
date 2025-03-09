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
        ];
        vim.viAlias = true;
        vim.vimAlias = true;

        vim.extraLuaFiles =
          builtins.map (
            p:
              builtins.path {
                path = p;
                name = builtins.baseNameOf (builtins.toString p);
              }
          ) [
            ./config.lua
            ./remap.lua
            ./neovide.lua
          ];

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
