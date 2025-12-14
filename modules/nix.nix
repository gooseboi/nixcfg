{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    const
    filterAttrs
    isType
    mapAttrs
    mapAttrsToList
    ;
  inputFlakes =
    inputs
    |> filterAttrs (isType "flake" |> const);
in {
  # Some of these are stolen from here:
  # https://github.com/RGBCube/ncc/blob/94c349aa767f04f40ff4165c70c15ed3c3996f82/modules/common/nix.nix

  # This is to prevent the downloaded flakes' source code from being garbage
  # collected
  environment.etc.".system-inputs.json".text = builtins.toJSON inputFlakes;

  nix = {
    channel = {enable = false;};

    optimise = {
      automatic = true;

      dates = "*-*-* 00:00:00";
      persistent = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";

      dates = "daily";
      persistent = true;
    };

    registry =
      inputFlakes
      |> mapAttrs (_: flake: {inherit flake;});

    # Even though I don't like using channels and disable them above, some
    # `shell.nix`s shared online use <nixpkgs> to get the system nixpkgs, and
    # since there are no downsides to adding the flakes to the nix search path
    # to support this, as there is no way to change what these values point to,
    # I just do it.
    nixPath =
      inputFlakes
      |> mapAttrsToList (name: value: "${name}=${value}");
  };

  environment.systemPackages = with pkgs; [
    nh
    nix-index
    nix-output-monitor
    nix-tree
  ];
}
