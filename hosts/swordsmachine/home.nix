{
  config,
  pkgs,
  ...
}: {
  chonkos = {
    user = "chonk";

    eza.enable = true;
    zsh = {
      enable = true;
      enableVimMode = true;
      enableFzfIntegration = true;
    };
    tmux = {
      enable = true;
    };
    nvim.enable = true;
    jujutsu.enable = true;
    utils.enable = true;
  };

  home = {
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
