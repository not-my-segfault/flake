{
  networking = {
    hostName = "nixos-laptop";
    interfaces = {
      enp3s0.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
  };

  services = {
    xserver.libinput.enable = true;
    tlp.enable = true;
    auto-cpufreq.enable = true;
  };

  system.stateVersion = "22.05";
}
