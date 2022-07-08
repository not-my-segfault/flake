{ pkgs, ... }:

{

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
    #   kernelParams = [ "cma=128M" ];
  };

  networking = {
    hostName = "nixos-rpi";
    networkmanager.enable = true;
    useDHCP = false;
    hosts = {
      "10.0.0.16" = [ "git.tar.black" ];
      "10.0.0.12" = [ "EPSON69B65D.local" ];
    };
    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services = { openssh.enable = true; };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [ libraspberrypi vim git helix ];

  system.stateVersion = "22.05";

}
