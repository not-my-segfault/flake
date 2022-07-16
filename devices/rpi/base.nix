{pkgs, ...}: {
  boot.loader.generic-extlinux-compatible.enable = false;

  networking = {
    hostName = "new-ewok";
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

  environment.systemPackages = with pkgs; [libraspberrypi];

  system.stateVersion = "22.05";
}
