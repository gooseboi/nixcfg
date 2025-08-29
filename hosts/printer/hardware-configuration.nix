{modulesPath, ...}: {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
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
