{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.nvim;
in {
  imports = [
    ./comment.nix
    ./easymotion.nix
    ./gruvbox.nix
    ./lualine.nix
    ./oil.nix
    ./telescope.nix
    # ./treesitter.nix
  ];

  options.chonkos.nvim = {
    enable = lib.mkEnableOption "enables neovim support";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.file.".config/nvim/lua/chonk/init.lua".text = ''
      require "chonk.config"
      require "chonk.filetypes"
      require "chonk.neovide"
      require "chonk.remap"
    '';
    home.file.".config/nvim/lua/chonk/config.lua".source = ./lua/config.lua;
    home.file.".config/nvim/lua/chonk/filetypes.lua".source = ./lua/filetypes.lua;
    home.file.".config/nvim/lua/chonk/neovide.lua".source = ./lua/neovide.lua;
    home.file.".config/nvim/lua/chonk/remap.lua".source = ./lua/remap.lua;

    programs.neovim = {
      enable = true;
      plugins = [pkgs.vimPlugins.lazy-nvim];
      extraLuaConfig = ''
        require "chonk"

        require("lazy").setup({
        	spec = {
        		{ import = "chonk/plugins" },
        	},
          rocks = { enabled = false },
          pkg = { enabled = false },
          install = { missing = false },
          change_detection = { enabled = false },
        })
      '';

      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        nixd
      ];
    };
  };
}
