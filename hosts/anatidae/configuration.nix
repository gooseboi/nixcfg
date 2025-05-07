{
  config,
  lib,
  ...
}: {
  # TODO: Impermanence (https://notthebe.ee/blog/nixos-ephemeral-zfs-root/)
  # TODO: lanzaboote (https://github.com/nix-community/lanzaboote)

  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ./syncthing.nix
    ./brave
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    binfmt = {
      emulatedSystems = ["aarch64-linux" "riscv64-linux"];
    };
  };

  programs.nix-ld.enable = true;

  time.timeZone = "America/Montevideo";

  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["wheel" "video" "audio" "dialout"];
    hashedPasswordFile = config.age.secrets.chonk-hashedPassword.path;
  };

  home-manager.users.chonk = import ./home.nix;

  chonkos = {
    user = "chonk";

    agenix.enable = true;
    desktop.enable = true;
    docker.enable = true;
    fonts.enable = true;
    hyprland.enable = true;
    i18n.enable = true;
    network-manager.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    tlp.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;
    zsh.enableVimMode = true;
  };

  # When on the default "powersave", then the frequency is stuck on 0.8GHz,
  # pretty unusable.
  services.tlp.settings.CPU_SCALING_GOVERNOR_ON_BAT = lib.mkForce "performance";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # This shouldn't be changed
}
