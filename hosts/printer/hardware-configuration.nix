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
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "dwc3_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_acpi"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };
}
