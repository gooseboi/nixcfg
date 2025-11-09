# This is taken from the service file in nixpkgs (as of
# d916df777523d75f7c5acca79946652f032f633e), but modified to run as the
# `anki-sync-server` user instead.
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  inherit
    (lib)
    attrsToList
    concatMapStringsSep
    escapeShellArg
    filter
    getExe
    hasPrefix
    lists
    mkEnableOption
    mkIf
    mkOption
    removePrefix
    types
    ;

  cfg = config.chonkos.services.anki-sync-server;
  name = "anki-sync-server";
  user = "anki-sync-server";
  group = "anki-sync-server";

  users =
    cfg.users
    |> attrsToList
    |> map (u: {username = u.name;} // u.value)
    |> filter (u: u.password != null || u.passwordFile != null);

  usersWithIndexes =
    users
    |> lists.imap1 (i: user: {
      inherit i user;
    });
  usersWithIndexesFile =
    usersWithIndexes
    |> filter (x: x.user.passwordFile != null);
  usersWithIndexesNoFile =
    usersWithIndexes
    |> filter (
      x: x.user.passwordFile == null && x.user.password != null
    );
in {
  options.chonkos.services.anki-sync-server = {
    enable = mkEnableOption "enable anki-sync-server";

    package = mkOption {
      description = "the package to run";
      default = pkgs.anki-sync-server;
    };

    bindAddress = mkOption {
      description = "the address to bind to";
      default = "0.0.0.0";
      type = types.str;
    };

    bindPort = mkOption {
      description = "the address to bind to";
      default = 5701;
      type = types.port;
    };

    user = mkOption {
      default = "anki-sync-server";
      type = types.str;
      description = "user which runs anki-sync-server";
    };

    group = mkOption {
      default = "anki-sync-server";
      type = types.str;
      description = "group which runs anki-sync-server";
    };

    stateDir = mkOption {
      default = "/var/lib/anki-sync-server";
      type = types.str;
      description = "directory to put data in";
    };

    users = mkOption {
      type =
        types.attrsOf
        <| types.submodule {
          options = {
            password = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Password accepted by anki-sync-server for the associated username.
                **WARNING**: This option is **not secure**. This password will
                be stored in *plaintext* and will be visible to *all users*.
                See {option}`chonkos.services.anki-sync-server.users.passwordFile` for
                a more secure option.
              '';
            };
            passwordFile = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = ''
                File containing the password accepted by anki-sync-server for
                the associated username.
                Make sure to make readable by the `anki-sync-server` user.
              '';
            };
          };
        };
      description = "List of user-password pairs to provide to the sync server.";
    };

    hashPasswords = mkEnableOption ''
      Whether passwords are read as hashes or as plain-text passwords.
      This applies for all users, and cannot be configured on a per-user basis (this
      is a limitation of the sync server)
    '';
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasPrefix "/var/lib/" cfg.stateDir;
        message = "${name} data dir must be prefixed with `/var/lib`, was ${cfg.stateDir}";
      }
    ];

    users = {
      users.${user} = {
        inherit group;
        isSystemUser = true;
      };
      groups.${group} = {};
    };

    systemd.services.${name} = {
      description = "anki-sync-server: Anki sync server built into Anki";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      path = [cfg.package];
      environment = {
        SYNC_BASE = cfg.stateDir;
        SYNC_HOST = cfg.bindAddress;
        SYNC_PORT = toString cfg.bindPort;
        PASSWORDS_HASHED = mkIf cfg.hashPasswords "1";
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        StateDirectory = removePrefix "/var/lib/" cfg.stateDir;
        ReadWritePaths = [
          cfg.stateDir
        ];

        # FIXME: The service doesn't restart if the passwordfile's
        # contents changes?
        ExecStart = pkgs.writeShellScript "anki-sync-server-run" ''
          # When passwordFile is set, each password file's path is passed in a
          # systemd credential. Here we read the passwords from the credential
          # files to pass them as environment variables to the Anki sync
          # server.
          ${
            usersWithIndexesFile
            |> concatMapStringsSep "\n" (x: ''
              read -r pass < "''${CREDENTIALS_DIRECTORY}/"${escapeShellArg x.user.username}
              export SYNC_USER${toString x.i}=${escapeShellArg x.user.username}:"$pass"
            '')
          }

          # For users where passwordFile isn't set,
          # export passwords in environment variables in plaintext.
          ${concatMapStringsSep "\n" (
              x: ''export SYNC_USER${toString x.i}=${escapeShellArg x.user.username}:${escapeShellArg x.user.password}''
            )
            usersWithIndexesNoFile}

          exec ${getExe cfg.package}
        '';
        Restart = "always";
        LoadCredential =
          usersWithIndexesFile
          |> map (
            x: "${x.user.username}:${toString x.user.passwordFile}"
          );

        # Hardening
        NoNewPrivileges = true;
        CapabilityBoundingSet = [""];
        RemoveIPC = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    chonkos.services.reverse-proxy.hosts.anki = {
      inherit (cfg) enable;

      target = "http://${cfg.bindAddress}:${toString cfg.bindPort}";
      targetType = "tcp";
      remote = "http://anki.${domain}";
    };
  };
}
