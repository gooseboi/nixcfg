{
  lib,
  pkgs,
  ...
}: let
in {
  nix = {
    channel = {enable = false;};
  };

  environment.systemPackages = with pkgs; [
    nh
    nix-index
    nix-output-monitor
    nix-tree
  ];
}
