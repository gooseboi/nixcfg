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

  options.chonkos = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "chonk";
      description = "the user to add the modules to";
      readOnly = true;
    };
  };
}
