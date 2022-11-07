{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "nixos-station";
    nameservers = ["10.0.0.16"];
    interfaces = {
      eno1.useDHCP = true;
      wlp4s0.useDHCP = true;
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;

  system.stateVersion = "22.11";
}
