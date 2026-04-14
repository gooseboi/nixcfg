{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkForce
    mkIf
    ;
in {
  config = mkIf config.services.syncthing.enable {
    systemd.services = {
      syncthing-init = {
        wantedBy = mkForce ["syncthing.service"];
        after = ["syncthing.service"];
        partOf = ["syncthing.service"];
      };

      syncthing = {
        environment.STNODEFAULTFOLDER = "true";

        # Hardening
        serviceConfig = {
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
    };

    services.syncthing = {
      user = config.chonkos.user;

      overrideDevices = true;
      overrideFolders = true;

      settings = {
        gui = {
          theme = "dark";
        };

        options.urAccepted = -1; # Disable telemetry.
      };
    };
  };

  # TODO: I'd like the gui to listen on a unix domain socket to avoid using a
  # port,but syncthing-init breaks because of bad quoting and I cannot be
  # bothered to open the issue, and therefore I will leave a sample config here
  # so I can check back on this someday.

  # services.syncthing.guiAddress = "/run/syncthing/syncthing.sock";
  # # Ensure the runtime directory ("/run/syncthing") exists and
  # # has correct perms.
  # systemd.services.syncthing.serviceConfig = {
  #   StateDirectory = "syncthing";
  #   StateDirectoryMode = "0700";
  #   RuntimeDirectory = "syncthing";
  #   RuntimeDirectoryMode = "0750";
  # };
}
