{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  inherit (lib) mkConst;

  cfg = config.chonkos.services.forgejo;
  serviceDomain = "${cfg.serviceSubDomain}.${domain}";
in {
  # TODO: Repo code indexing (https://forgejo.org/docs/latest/admin/config-cheat-sheet/#indexer-indexer)
  # TODO: Prometheus (https://forgejo.org/docs/latest/admin/config-cheat-sheet/#metrics-metrics)

  options.chonkos.services.forgejo = {
    enable = mkConst true;
    enableReverseProxy = mkConst true;
    serviceName = mkConst "forgejo";
    servicePort = mkConst 3000;
    serviceDir = mkConst "/var/lib/forgejo";
    serviceSubDomain = mkConst "git";
  };

  config = {
    services.forgejo = {
      inherit (cfg) enable;

      stateDir = cfg.serviceDir;

      package = pkgs.forgejo;

      lfs.enable = true;

      database.type = "sqlite3";

      settings = {
        DEFAULT.APP_NAME = "Chonk's terrible git repos";

        server = {
          DOMAIN = serviceDomain;
          SSH_DOMAIN = serviceDomain;
          HTTP_PORT = cfg.servicePort;
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

        "git.timeout" = {
          MIGRATE = 7200;
          MIRROR = 7200;
          GC = 7200;
        };

        ui.DEFAULT_THEME = "forgejo-dark";

        actions.ENABLED = false;
      };
    };
  };
}
