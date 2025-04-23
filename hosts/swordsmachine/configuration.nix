{config, ...}: {
  imports = [
    ./disk-config.nix
    ./freedns.nix
    ./hardware-configuration.nix
    ./services
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
  home-manager.users.chonk = import ./home.nix;

  chonkos = {
    user = "chonk";

    agenix.enable = true;
    docker.enable = true;
    i18n.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    theme.enable = false;
    tailscale.enableExitNode = true;
    tailscale.preferredInterface = "enig0";
    tlp.enable = true;
    zsh.enable = true;
    zsh.enableVimMode = true;
  };

  systemd.network = {
    enable = true;
    links = {
      "10-enig0" = {
        matchConfig.MACAddress = "40:ae:30:b2:d7:fe";
        linkConfig.Name = "enig0";
      };
    };
  };
  networking = {
    useDHCP = true;
    interfaces.enig0.useDHCP = true;
    domain = "gooseman.net";
  };

  services.logind.lidSwitch = "ignore";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # This shouldn't be changed
}
