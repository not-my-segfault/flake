{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = ["usb_storage" "usbhid" "uas"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-label/SWAP";}];

  networking = {
    useDHCP = lib.mkDefault false;
    interfaces = {
      eth0.useDHCP = lib.mkDefault true;
      wlan0.useDHCP = lib.mkDefault true;
    };
  };
}
