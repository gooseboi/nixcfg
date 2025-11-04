_: self: super: let
  inherit (super) mkEnableOption mkOption types;
in {
  mkConst = value:
    mkOption {
      default = value;
      readOnly = true;
    };

  mkValue = default:
    mkOption {
      inherit default;
    };

  mkDisableOption = description: (mkEnableOption description) // {default = true;};

  mkBoolOption = description: default:
    mkOption {
      inherit default description;
      type = types.bool;
    };
}
