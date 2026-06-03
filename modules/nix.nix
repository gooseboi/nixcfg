{
  config,
  inputs,
  keys,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit
    (lib)
    const
    filterAttrs
    isType
    mapAttrs
    mapAttrsToList
    mkDisableOption
    mkEnableOption
    mkIf
    ;

  inputFlakes =
    inputs
    |> filterAttrs (name: value: name != "self")
    |> filterAttrs (isType "flake" |> const);

  cfg = config.chonkos.nix;
in {
  options.chonkos.nix = {
    # The default is enabled because I'd like most machines to not be able to build
    disableLocalBuilds = mkDisableOption "make this machine unable to execute builds";
    useRemoteBuild = mkEnableOption "make this machine use remote builders";
    isRemoteBuilder = mkEnableOption "mark this machine as avaiable to run remote builds for others";
  };

  config = {
    assertions = [
      {
        assertion = cfg.disableLocalBuilds -> cfg.useRemoteBuild;
        message = "if local builds are disabled then remote builds must be enabled";
      }
    ];

    # Some of these are stolen from here:
    # https://github.com/RGBCube/ncc/blob/94c349aa767f04f40ff4165c70c15ed3c3996f82/modules/common/nix.nix

    # This is to prevent the downloaded flakes' source code from being garbage
    # collected
    environment.etc.".system-inputs.json".text = builtins.toJSON inputFlakes;

    nix = {
      settings = {
        experimental-features = [
          "cgroups"
          "flakes"
          "nix-command"
          "pipe-operators"
        ];

        trusted-users = ["root" "@builder" "@wheel"];
        warn-dirty = false;
        use-cgroups = true;
        use-xdg-base-directories = true;
      };

      channel = {enable = false;};

      optimise = {
        automatic = true;

        dates = "*-*-* 00:00:00";
        persistent = true;
      };

      gc = {
        automatic = true;
        options = "--delete-older-than 3d";

        dates = "daily";
        persistent = true;
      };

      registry =
        inputFlakes
        |> mapAttrs (_: flake: {inherit flake;});

      # Even though I don't like using channels and disable them above, some
      # `shell.nix`s shared online use <nixpkgs> to get the system nixpkgs, and
      # since there are no downsides to adding the flakes to the nix search path
      # to support this, as there is no way to change what these values point to,
      # I just do it.
      nixPath =
        inputFlakes
        |> mapAttrsToList (name: value: "${name}=${value}");

      settings.max-jobs = mkIf cfg.disableLocalBuilds 0;
      distributedBuilds = cfg.useRemoteBuild;
      buildMachines =
        mkIf cfg.useRemoteBuild
        (
          self.nixosConfigurations
          |> filterAttrs (
            name: value:
              value.config.chonkos.nix.isRemoteBuilder
              && name != config.networking.hostName
          )
          |> mapAttrsToList (
            name: value: {
              # Connect through tailscale
              hostName = name;
              sshUser = "builder";
              protocol = "ssh-ng";

              sshKey = config.age.secrets.builder-sshkey.path;

              systems =
                if value.config.chonkos.binfmt.enable
                then
                  value.config.boot.binfmt.emulatedSystems
                  ++ [value.config.nixpkgs.hostPlatform.system]
                else [value.config.nixpkgs.hostPlatform.system];

              # Default is 1 but may keep the builder idle in between builds
              maxJobs = 3;

              supportedFeatures = ["big-parallel" "kvm" "nixos-test"];
            }
          )
        );
    };

    age.secrets = lib.mkIf config.chonkos.nix.useRemoteBuild {
      builder-sshkey = {
        mode = "400";
        file = ./secrets/builder-sshkey.age;
      };
    };
    users = mkIf cfg.isRemoteBuilder {
      groups.builder = {};
      users.builder = {
        isSystemUser = true;
        createHome = true;
        group = "builder";
        home = "/var/empty";
        shell = pkgs.bashInteractive;
        openssh.authorizedKeys.keys = [keys.builder];
      };
    };

    environment.systemPackages = with pkgs; [
      nh
      nix-index
      nix-output-monitor
      nix-tree
    ];
  };
}
