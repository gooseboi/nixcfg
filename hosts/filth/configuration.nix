{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    ./disk-config.nix
  ];

  boot.loader = {
    grub.enable = true;
    efi.canTouchEfiVariables = true;
  };

  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUT9jJWba9PeWFpaEyypGMSk1F4hO5rYwtiruh9+uZ"
    ];
  };

  chonkos = {
    tailscale.enable = true;
    openssh.enable = true;
    zsh.enable = true;
  };

  system.stateVersion = "24.05"; # This shouldn't be changed
}
