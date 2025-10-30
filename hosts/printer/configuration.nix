{
  config,
  keys,
  ...
}: {
  imports =
    [
      ./disk-config.nix
      ./hardware-configuration.nix
    ]
    ++ [
      ./printer
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
    tailscale.preferredInterface = "enig0";
    utils.enable = true;
    zsh.enable = true;
    zsh.enableUserShell = true;
    zsh.enableVimMode = true;
  };

  systemd.network = {
    enable = true;
    links = {
      "10-enig0" = {
        matchConfig.MACAddress = "24:1c:04:78:93:5c";
        linkConfig.Name = "enig0";
      };
    };
  };
  networking = {
    useDHCP = true;
    interfaces.enig0.useDHCP = true;
    domain = "gooseman.net";
  };

  system.stateVersion = "25.05"; # This shouldn't be changed
}
