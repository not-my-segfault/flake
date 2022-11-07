{lib, ...}: {
  boot = {
    cleanTmpDir = true;
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    nameservers = ["10.0.0.16"];
    hosts = {
      "10.0.0.16" = ["git.tar.black" "tar.black" "tar"];
    };
  };

  time.timeZone = "Europe/London";

  fileSystems = {
    "/" = lib.mkDefault {
      device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };
  };

  zramSwap.enable = true;

  swapDevices = [{device = "/dev/disk/by-label/SWAP";}];
}
