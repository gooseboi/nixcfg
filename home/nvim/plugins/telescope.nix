{pkgs, ...}: {
  isDesktop = true;

  packages = with pkgs; [
    ripgrep
    git
    fd
  ];

  config = pkgs.replaceVarsWith {
    src = ./configs/telescope.lua;
    replacements = with pkgs.vimPlugins; {
      inherit telescope-nvim plenary-nvim telescope-fzf-native-nvim;
    };
  };
}
