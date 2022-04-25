{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f8389135-3bf7-4f32-90f7-af973386d673";
    fsType = "btrfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B35C-A89E";
    fsType = "vfat";
  };

  fileSystems."/hdd" = {
    device = "/dev/disk/by-uuid/51f3b84c-2bf2-4cda-a514-d6d912e63e32";
    fsType = "btrfs";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7159a906-144c-4cd4-8b24-831240bdc992"; }];

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
