_: _: super: let
  inherit (super) mkOption mkEnableOption;
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

  mkDisableOption = s: ((mkEnableOption s) // {default = true;});
}
