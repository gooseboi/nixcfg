inputs: self: super: let
  option = import ./option.nix inputs self super;
  system = import ./system.nix inputs self super;
in
  option // system
