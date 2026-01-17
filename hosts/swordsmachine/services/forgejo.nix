{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
  inherit (config.networking) domain;

  enable = true;

  port = 3000;
  dataDir = "/var/lib/forgejo";
  package = pkgs.forgejo;
  subDomain = "git";

  serviceDomain = "${subDomain}.${domain}";
in {
  # TODO: Prometheus (https://forgejo.org/docs/v13.0/admin/config-cheat-sheet/#metrics-metrics)

  config = mkIf enable {
    environment.systemPackages = [
      package
    ];

    services.restic.backups.computer = {
      paths = [dataDir];
      exclude = [
        # This directory stores archives created when clicking "Download as
        # ZIP" or related api. These files are generated and therefore don't
        # need backing up
        "${dataDir}/data/repo-archive"

        # All files in these directories are symlinked from the nix store
        "${dataDir}/conf"

        # These are because the forgejo user's home directory is in the data
        # directory
        "${dataDir}/.bash_history"
        "${dataDir}/.psql_history"

        # I don't care about whatever could be here
        "${dataDir}/dump"
        "${dataDir}/indexers"
        "${dataDir}/log"

        # Tempfiles for git gc
        "${dataDir}/repositories/**/*.git/objects/pack/.tmp*pack"
      ];
    };

    services.forgejo = {
      inherit enable;

      stateDir = dataDir;

      inherit package;

      lfs.enable = true;

      database.type = "sqlite3";

      # https://forgejo.org/docs/v13.0/admin/config-cheat-sheet/
      settings = {
        DEFAULT.APP_NAME = "Chonk's terrible git repos";

        server = {
          DOMAIN = serviceDomain;
          SSH_DOMAIN = serviceDomain;
          HTTP_PORT = port;
          HTTP_ADDR = "127.0.0.1";
          DISABLE_SSH = false;
          ROOT_URL = "https://${serviceDomain}";
        };

        repository = {
          DEFAULT_BRANCH = "master";
          DEFAULT_MERGE_STYLE = "rebase-merge";
          DEFAULT_REPO_UNITS = "repo.code, repo.issues, repo.pulls";

          DEFAULT_PUSH_CREATE_PRIVATE = false;
          ENABLE_PUSH_CREATE_ORG = true;
          ENABLE_PUSH_CREATE_USER = true;

          DISABLE_STARS = true;
        };

        service = {
          DISABLE_REGISTRATION = true;
          REQUIRE_SIGNIN_VIEW = false;
          REGISTER_EMAIL_CONFIRM = false;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
          ENABLE_CAPTCHA = false;
          DEFAULT_KEEP_EMAIL_PRIVATE = false;
          DEFAULT_ALLOW_CREATE_ORGANIZATION = false;
          DEFAULT_ENABLE_TIMETRACKING = true;
        };

        cron = {
          RUN_AT_START = false;
          NOTICE_ON_SUCCESS = true;
        };

        "cron.git_gc_repos" = {
          ENABLED = true;
          RUN_AT_START = false;
          SCHEDULE = "@midnight";
          TIMEOUT = "180s";
          NOTICE_ON_SUCCESS = true;
        };

        "cron.delete_old_actions" = {
          ENABLED = true;
          RUN_AT_START = false;
          NOTICE_ON_SUCCESS = true;
          SCHEDULE = "@midnight";
          # 1 year
          OLDER_THAN = "8760h";
        };

        "git.timeout" = {
          MIGRATE = 2 * 60 * 60;
          MIRROR = 2 * 60 * 60;
          GC = 2 * 60 * 60;
        };

        mirror = {
          ENABLED = true;
          DEFAULT_INTERVAL = "4h";
          MIN_INTERVAL = "10m";
        };

        ui.DEFAULT_THEME = "forgejo-dark";

        actions.ENABLED = false;
      };
    };

    chonkos.services.reverse-proxy.hosts.forgejo = {
      target = "http://127.0.0.1:${toString port}";
      targetType = "tcp";
      domain = "${serviceDomain}";
      enableAnubis = true;
    };
  };
}
