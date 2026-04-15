{
  modulesPath,
  inputs,
  ...
}: let
  hw = inputs.nixos-hardware.nixosModules;
in {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    hw.common-cpu-amd
    hw.common-cpu-amd-pstate
    hw.common-cpu-amd-zenpower
    hw.common-gpu-amd
    hw.common-pc-laptop-ssd
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
      kernelModules = [];
    };

    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };
}
