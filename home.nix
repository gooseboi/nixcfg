{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home/git.nix
    ./home/alacritty.nix
  ];

  home.username = "chonk";
  home.homeDirectory = "/home/chonk";

  home.stateVersion = "24.11";

  home.packages = with pkgs;
    [
      # Utils
      btop
      btrfs-progs
      dosfstools
      dust
      exfatprogs
      fd
      ffmpeg-full
      fzf
      htop
      libqalculate
      man
      man-db
      man-pages
      man-pages-posix
      ntfs3g
      p7zip
      socat
      tealdeer
      unzip

      # Dev
      odin
      python3
      zig

      # Typesetting
      texliveFull
      typst

      # Fonts
      libertinus
      noto-fonts
      noto-fonts-color-emoji
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues nerd-fonts);

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
