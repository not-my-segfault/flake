{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "usb_storage" "usbhid" "uas" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2310a805-21a9-48d5-a6e9-202632025c04";
    fsType = "btrfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/767B-DEFE";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/8f8f731f-be83-4f9f-a9ba-d009d376673b"; }];

  networking = {
    useDHCP = lib.mkDefault false;
    interfaces = {
      eth0.useDHCP = lib.mkDefault true;
      wlan0.useDHCP = lib.mkDefault true;
    };
  };

}
