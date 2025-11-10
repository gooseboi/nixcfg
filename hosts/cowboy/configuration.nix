{keys, ...}: {
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
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
    password = "1234";
    openssh.authorizedKeys.keys = [
      keys.chonk
    ];
  };

  home-manager.users.chonk = {
    chonkos = {
      user = "chonk";

      eza.enable = true;
      tmux.enable = true;
    };

    home.stateVersion = "24.11";
  };

  chonkos = {
    type = "server";
    user = "chonk";

    agenix.enable = true;
    i18n.enable = true;
    neovim.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    tailscale.enableExitNode = true;
    utils.enable = true;
    zsh.enable = true;
    zsh.enableUserShell = true;
    zsh.enableVimMode = true;
  };

  networking = {
    useDHCP = true;
    domain = "gooseman.net";
  };

  system.stateVersion = "25.05"; # This shouldn't be changed
}
