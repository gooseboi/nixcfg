{
  modulesPath,
  inputs,
  ...
}: let
  hw = inputs.nixos-hardware.nixosModules;
in {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    hw.common-cpu-intel
    hw.common-gpu-intel
    hw.common-pc-laptop-ssd
  ];

  hardware.intelgpu.enableHybridCodec = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
}
