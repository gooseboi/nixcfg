{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf remove;

  cfg = config.chonkos.binfmt;
in {
  options.chonkos.binfmt = {
    enable = mkEnableOption "enable binfmt registrations";
  };

  config = mkIf cfg.enable {
    boot.binfmt = {
      # Blatantly stolen from https://github.com/RGBCube/NCC/blob/06cce18e7259e060a65af2af2bf0e609cd8e9a2c/modules/linux/emulated-systems.nix
      emulatedSystems = remove config.nixpkgs.hostPlatform.system [
        "aarch64-linux"
        "riscv64-linux"
        "x86_64-linux"
      ];
    };
  };
}
