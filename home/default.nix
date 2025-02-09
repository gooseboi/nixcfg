{...}: {
  imports =
    [
      ./alacritty.nix
      ./eza.nix
      ./git.nix
      ./hyprland.nix
      ./jujutsu.nix
      ./tmux.nix
      ./zathura.nix
      ./zsh.nix
    ]
    ++ [
      ./scripts
    ];
}
