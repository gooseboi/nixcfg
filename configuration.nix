{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.luks.devices."luks-d2e00eab-b629-46f1-8127-283fe4bba9eb".device = "/dev/disk/by-uuid/d2e00eab-b629-46f1-8127-283fe4bba9eb";
  };
  networking.hostName = "anatidae";

  # TODO: network-manager wireless
  # networking.wireless.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.networkmanager.enable = true;

  time.timeZone = "America/Montevideo";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services = {
    xserver.enable = true;

    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chonk = {
    isNormalUser = true;
    description = "chonk";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.chonk = import ./home.nix;
  };

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    neovim.enable = true;
  };

  environment.pathsToLink = ["/share/zsh"];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05"; # This shouldn't be changed
}
