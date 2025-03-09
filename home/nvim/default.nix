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
        vim.viAlias = true;
        vim.vimAlias = true;

        imports = [
          ./comment.nix
          ./easymotion.nix
          ./gruvbox.nix
          ./lualine.nix
          ./oil.nix
          ./telescope.nix
          ./treesitter.nix
        ];

        vim.extraLuaFiles = builtins.map (
          p:
            builtins.path {
              path = p;
              name = builtins.baseNameOf (builtins.toString p);
            }
        ) (lib.attrsets.mapAttrsToList (name: value: ./lua + /${name}) (builtins.readDir ./lua));

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
