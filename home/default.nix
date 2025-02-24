{...}: {
  imports =
    [
      ./alacritty.nix
      ./eza.nix
      ./fonts.nix
      ./git.nix
      ./jujutsu.nix
      ./tmux.nix
      ./zathura.nix
      ./zsh.nix
    ]
    ++ [
      ./hyprland
      ./scripts
    ];
}
