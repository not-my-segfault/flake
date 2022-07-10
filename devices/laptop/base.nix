{
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  networking = {
    hostName = "nixos-laptop";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp3s0.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
  };

  time.timeZone = "Europe/London";

  services = {
    xserver.libinput.enable = true;
    tlp.enable = true;
    auto-cpufreq.enable = true;
  };

  system.stateVersion = "22.05";
}
