{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems."/hdd" = {
    device = "/dev/disk/by-label/HDD";
    fsType = "btrfs";
  };

  networking = {
    useDHCP = lib.mkDefault false;
    interfaces = {
      eno1.useDHCP = lib.mkDefault true;
      wlp4s0.useDHCP = lib.mkDefault true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
