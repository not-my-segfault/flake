{ pkgs, ... }:

{

  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  programs = {
    steam.enable = true;
    kdeconnect.enable = true;
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [ 
        epson-escpr
        epson-escpr2
      ];
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gamemode
    kdenlive
    krita
    lutris
    obs-studio
    polymc
    skypeforlinux
    spotify
    vulkan-tools
    wine
    wine64
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

}
