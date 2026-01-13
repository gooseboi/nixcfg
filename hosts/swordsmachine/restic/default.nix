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

    # 1 / fps = seconds per update
    progressFps = 0.1;

    extraBackupArgs = [
      # Speed in KB.
      # This limit is to not overwhelm my home network when performing the
      # backup because sometimes I'm a little naughty and stay up late and I
      # don't want the internet to be interrupted for like 20 minutes.
      "--limit-upload=2048"
    ];

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
