{config, ...}: {
  age.secrets = {
    restic-password.file = ./restic-password.age;
    restic-envfile.file = ./restic-envfile.age;
  };

  services.restic.backups.computer = {
    repository = "s3:s3.us-east-005.backblazeb2.com/swordsmachine-backup";
    environmentFile = config.age.secrets.restic-envfile.path;
    passwordFile = config.age.secrets.restic-password.path;
    initialize = true;

    inherit
      (config.chonkos.services.restic.backups.computer)
      backupPrepareCommand
      backupCleanupCommand
      ;

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
