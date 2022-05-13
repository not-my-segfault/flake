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
    hosts = {
      "10.0.0.16" = [ "git.tar.black" ];
      "10.0.0.12" = [ "EPSON69B65D.local" ];
    };
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
