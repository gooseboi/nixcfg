{lib, ...}: {
  imports =
    [
      ./agenix.nix
      ./docker.nix
      ./fonts.nix
      ./hyprland.nix
      ./i18n.nix
      ./network-manager.nix
      ./nix-ld.nix
      ./ssh.nix
      ./systemd.nix
      ./tailscale.nix
      ./theme.nix
      ./tlp.nix
      ./users.nix
      ./virt-manager.nix
      ./zsh.nix
    ]
    ++ [
      ./desktop
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
