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
      ./hyprland.nix
      ./i18n.nix
      ./mosh.nix
      ./network-manager.nix
      ./ssh.nix
      ./tailscale.nix
      ./tlp.nix
      ./users.nix
      ./virt-manager.nix
      ./zsh.nix
    ]
    ++ [
      ./secrets
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
