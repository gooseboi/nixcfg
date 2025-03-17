{
  pkgs,
  lib,
  ...
}: {
  imports =
    [
      ./network-manager.nix
      ./ssh.nix
      ./tailscale.nix
      ./zsh.nix
    ]
    ++ [
      ./secrets
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
