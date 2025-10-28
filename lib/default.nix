{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  mkExtend = self: super: let
    option = import ./option.nix inputs self super;
    system = import ./system.nix inputs self super;
    filesystem = import ./filesystem.nix inputs self super;
    utils = import ./utils.nix inputs self super;
  in
    option // system // filesystem // utils;

  myLib = lib.extend mkExtend;
in {
  flake = {
    # We set this as an output of the flake so it can be accessed as `self.lib`
    # when outside of a nixos module.
    #
    # Ideally, we'd override this using `_module.args.lib`, but that doesn't
    # work for some reason.
    lib = myLib;
  };
}
