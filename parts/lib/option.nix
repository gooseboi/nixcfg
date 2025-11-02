_: self: super: let
  inherit (super) mkEnableOption mkOption types;
in rec {
  mkConst = value:
    mkOption {
      default = value;
      readOnly = true;
    };

  mkValue = default:
    mkOption {
      inherit default;
    };

  mkDisableOption = s: ((mkEnableOption s) // {default = true;});

  mkBoolOption = description: default:
    mkOption {
      inherit default description;
      type = super.types.bool;
    };

  mkService = {
    name,
    port,
    dir,
    package,
    subDomain ? throw "Missing argument subDomain for web service",
    extraOpts ? {},
  }:
    {
      enable = mkEnableOption "enable ${name} service";
      name = mkConst name;
      port = mkOption {
        type = types.int;
        default = port;
        description = "The port ${name} will listen on";
      };
      dataDir = mkOption {
        type = types.str;
        default = dir;
        description = "The directory where ${name}'s data is stored";
      };
      subDomain = mkOption {
        type = types.str;
        default = subDomain;
        description = "The subDomain to use for ${name}. Also used for reverse proxying";
      };
    }
    // (
      if package != null
      then {
        package = mkOption {
          type = types.package;
          default = package;
          description = "The package to use for ${name}";
        };
      }
      else {}
    )
    // extraOpts;
}
