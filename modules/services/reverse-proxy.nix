{lib, ...}: let
  inherit
    (lib)
    mkDisableOption
    mkEnableOption
    mkOption
    types
    ;
in {
  options.chonkos.services.reverse-proxy = {
    hosts = mkOption {
      default = {};
      description = "Attribute set of hosts that want to be reverse proxied";
      type =
        types.attrsOf
        <| types.submodule {
          options = {
            enable = mkDisableOption "enable reverse proxying of this host";

            target = mkOption {
              description = "target to proxy requests to";
              type = types.str;
            };

            targetType = mkOption {
              description = "the type of the target's address";
              type = types.enum ["tcp" "unix"];
            };

            domain = mkOption {
              description = "domain to match incoming requests from";
              type = types.str;
            };

            enableAnubis = mkEnableOption "enable also proxying this host behind anubis";

            anubisAllowedPaths = mkOption {
              default = [];
              description = "List of regexes for paths that should be automatically allowed by Anubis (APIs, usually)";
              type =
                types.listOf
                <| types.submodule {
                  options = {
                    name = mkOption {
                      description = "the name of the rule in anubis";
                      type = types.str;
                    };
                    regex = mkOption {
                      description = "the regex to match the path with";
                      type = types.str;
                    };
                  };
                };
            };

            enableCompression = mkEnableOption "whether to enable compression for this host";

            enabledCompressionAlgorithms = mkOption {
              default = [];
              description = "List of compression algorithms to offer for this host. Empty list chooses proxy default";
              type =
                types.listOf
                <| types.enum ["gzip" "zstd"];
            };

            extraCaddyConfig = mkOption {
              description = "extra config to pass to caddy";
              default = "";
              type = types.lines;
            };
          };
        };
    };
  };
}
