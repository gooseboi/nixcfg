{
  config,
  pkgs,
  ...
}: {
  chonkos = {
    user = "chonk";

    hyprland.enable = true;
    alacritty.enable = true;
    eza.enable = true;
    zsh = {
      enable = true;
      enableVimMode = true;
      enableFzfIntegration = true;
    };
    tmux = {
      enable = true;
      enableSessionizer = true;
    };
    nvim.enable = true;
    zathura.enable = true;
    jujutsu.enable = true;
    scripts.enable = true;
    fonts.enable = true;
    rofi.enable = true;
    utils.enable = true;
    dev.enable = true;
    nushell.enable = true;
  };

  home = {
    stateVersion = "24.11";

    packages = with pkgs; [
      # Typesetting
      texliveFull
      typst
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
