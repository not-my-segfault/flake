{pkgs, ...}: {
  boot = {
    loader = {
      generic-extlinux-compatible.enable = false;
      systemd-boot = {
        enable = true;
        graceful = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 5;
    };
    # kernelParams = [ "cma=128M" ];
  };

  networking = {
    hostName = "nixos-rpi";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services = {
    openssh.enable = true;
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [libraspberrypi];

  system.stateVersion = "22.05";
}