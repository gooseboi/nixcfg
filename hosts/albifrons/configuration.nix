{
  config,
  keys,
  ...
}: {
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix

    ./services
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Chicago";

  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.chonk-hashedPassword.path;
    openssh.authorizedKeys.keys = [
      keys.chonk
    ];
  };

  home-manager.users = {
    chonk.home.stateVersion = "24.11";
  };

  chonkos = {
    type = "server";
    user = "chonk";

    deploy.enable = true;

    tailscale.enableExitNode = true;
    zsh.enableUserShell = true;
  };

  networking = {
    useDHCP = true;
    domain = "gooseman.net";
  };

  system.stateVersion = "25.05"; # This shouldn't be changed
}
