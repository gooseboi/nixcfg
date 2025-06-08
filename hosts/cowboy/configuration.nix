{config, ...}: {
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Montevideo";

  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["wheel" "video" "audio" "dialout"];
    hashedPasswordFile = config.age.secrets.chonk-hashedPassword.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUT9jJWba9PeWFpaEyypGMSk1F4hO5rYwtiruh9+uZ"
    ];
  };
  home-manager.users.chonk = {
    chonkos = {
      user = "chonk";

      eza.enable = true;
      tmux.enable = true;
      nvim.enable = true;
      nvim.server = true;
    };

    home.stateVersion = "24.11";
  };

  chonkos = {
    type = "server";
    user = "chonk";

    agenix.enable = true;
    i18n.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    # TODO: do
    # tailscale.enableExitNode = true;
    # tailscale.preferredInterface = "enig0";
    theme.enable = false;
    utils.enable = true;
    zsh.enable = true;
    zsh.enableVimMode = true;
  };

  networking = {
    domain = "gooseman.net";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # This shouldn't be changed
}
