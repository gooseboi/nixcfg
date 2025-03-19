{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos;
in {
  imports =
    [
      ./alacritty.nix
      ./desktop.nix
      ./dev.nix
      ./eza.nix
      ./fonts.nix
      ./git.nix
      ./jujutsu.nix
      ./rofi.nix
      ./tmux.nix
      ./utils.nix
      ./zathura.nix
      ./zsh.nix
    ]
    ++ [
      ./hyprland
      ./scripts
      ./nvim
    ];

  options.chonkos = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };
  };

  config = {
    home = {
      username = cfg.user;
      homeDirectory = "/home/${cfg.user}";
    };
  };
}
