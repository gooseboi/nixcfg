{lib, ...}: let
  inherit
    (lib)
    types
    mkOption
    ;
in {
  # The reason for the existence of this is because I would like to (possibly)
  # specify many `backupPrepareCommand`s, but the module specifies the option
  # as a types.str, so merging is disallowed. In this module it is defined as a
  # types.lines, which means that many definitions are merged, allowing for
  # multiple things to be backed up in the same backup.
  options.chonkos.services.restic.backups = mkOption {
    description = "custom backup configurations";
    type = types.attrsOf (
      types.submodule ({...}: {
        options = {
          backupPrepareCommand = mkOption {
            type = types.nullOr types.lines;
            default = null;
            description = ''
              A script that must run before starting the backup process.
            '';
          };

          backupCleanupCommand = mkOption {
            type = types.nullOr types.lines;
            default = null;
            description = ''
              A script that must run after finishing the backup process.
            '';
          };
        };
      })
    );
  };
}
