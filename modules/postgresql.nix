{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    mkOverride
    types
    ;

  cfg = config.chonkos.services.postgresql;
in {
  options.chonkos.services.postgresql = {
    enable = mkEnableOption "enable postgres";
    version = mkOption {
      description = "the version of postgres to run";
      default = 17;
      type = types.int;
    };

    ensure = mkOption {
      description = "list of databases to create";
      default = [];
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    chonkos.services.postgresql.ensure = ["root" "postgresql"];

    environment.systemPackages = with pkgs; [
      pgloader
    ];

    services.postgresql = {
      inherit (cfg) enable;
      package = pkgs."postgresql_${toString cfg.version}";

      enableJIT = true;
      initdbArgs = ["--locale=C" "--encoding=UTF8"];

      authentication = mkOverride 10 ''
        #     database  user    auth-method
        local all       all     peer
      '';

      ensureDatabases = cfg.ensure;

      ensureUsers =
        cfg.ensure
        |> map (name: {
          inherit name;

          ensureDBOwnership = true;

          ensureClauses = {
            login = true;
            superuser = name == "postgres" || name == "root";
          };
        });
    };
  };
}
