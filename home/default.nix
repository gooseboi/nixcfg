{...}: {
  imports =
    [
      ./alacritty.nix
      ./eza.nix
      ./fonts.nix
      ./git.nix
      ./jujutsu.nix
      ./rofi.nix
      ./tmux.nix
      ./zathura.nix
      ./zsh.nix
    ]
    ++ [
      ./hyprland
      ./scripts
      ./nvim
    ];
}
