{
  pkgs,
  lib,
  ...
}: {
  imports =
    [
      ./agenix.nix
      ./desktop.nix
      ./docker.nix
      ./network-manager.nix
      ./ssh.nix
      ./tailscale.nix
      ./tlp.nix
      ./virt-manager.nix
      ./zsh.nix
      ./alacritty.nix
    ]
    ++ [
      ./secrets
      ./nvim
      ./hyprland
    ];

  options.chonkos = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };
  };
}
