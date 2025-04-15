_: _: super: {
  mkConst = value:
    super.mkOption {
      default = value;
      readOnly = true;
    };
}
