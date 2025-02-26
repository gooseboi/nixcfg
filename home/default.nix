{...}: {
  imports =
    [
      ./alacritty.nix
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
}
