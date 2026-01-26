{
  config,
  keys,
  ...
}: {
  imports = [
    ./disk-config.nix
    ./freedns.nix
    ./hardware-configuration.nix
    ./minecraft.nix
    ./restic
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
      keys.chonk
    ];
  };
  home-manager.users.chonk = {
    chonkos = {
      user = "chonk";

      eza.enable = true;
      bat.enable = true;
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
    neovim.setEnvironment = true;
    openssh.enable = true;
    tailscale.enable = true;
    tailscale.enableExitNode = true;
    utils.enable = true;
    zsh.enable = true;
    zsh.enableUserShell = true;
    zsh.enableVimMode = true;
  };

  systemd.network = {
    enable = true;
    links = {
      "10-enig0" = {
        matchConfig.MACAddress = "c8:a3:62:04:20:44";
        linkConfig.Name = "enig0";
      };
    };
  };
  networking = {
    useDHCP = true;
    interfaces.enig0.useDHCP = true;
    domain = "gooseman.net";
  };

  services.logind.settings.Login.HandleLidSwitch = "ignore";

  boot.kernelParams = ["amd_pstate=guided"];
  powerManagement.enable = true;

  system.stateVersion = "24.05"; # This shouldn't be changed
}
