{ pkgs, ... }:

{

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
    };
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
      enabcm6e4ei0.useDHCP = true;
      wlan0.useDHCP = true;
    };
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  system.stateVersion = "22.05";

}
