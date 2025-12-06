{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
in {
  config = mkIf config.services.syncthing.enable {
    systemd.services = {
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
}
