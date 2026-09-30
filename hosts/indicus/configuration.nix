{config, ...}: {
  # TODO: Impermanence (https://notthebe.ee/blog/nixos-ephemeral-zfs-root/)
  # TODO: lanzaboote (https://github.com/nix-community/lanzaboote)
  # TODO: https://github.com/mrusme/usbec

  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ./syncthing.nix
    ./games.nix
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
  };

  home-manager.users = {
    chonk.home.stateVersion = "24.11";
  };

  chonkos = {
    type = "desktop";
    user = "chonk";
    nix.disableLocalBuilds = false;

    adb.enable = true;
    alacritty.enableEnvVar = true;
    docker.enable = true;
    helix.enable = true;
    hyprland.enable = true;
    hyprland.monitors = [
      {
        output = "eDP-1";
        mode = "1920x1080@60";
        position = "0x0";
        scale = 1;
      }
      {
        output = "HDMI-A-1";
        mode = "preferred";
        position = "auto";
        scale = 1;
        mirror = "eDP-1";
      }
    ];

    nushell.enable = true;
    virt-manager.enable = true;
    zsh.enableUserShell = true;
  };

  services.auto-cpufreq.enable = true;

  system.stateVersion = "24.05"; # This shouldn't be changed
}
