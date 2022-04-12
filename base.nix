{ pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      graceful = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  networking = {
    hostName = "nixos-station";
    useDHCP = false;
    hosts = {
      "10.0.0.15" = [ "git.tar.black" ];
      "10.0.0.12" = [ "EPSON69B65D.local" ];
    };
    interfaces = {
      eno1.useDHCP = true;
      wlp4s0.useDHCP = true;
    };
  };

  time.timeZone = "Europe/London";

  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "21.11";

}
