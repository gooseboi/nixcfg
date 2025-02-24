{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./ssh.nix
    ./tailscale.nix
    ./zsh.nix
  ];
}
