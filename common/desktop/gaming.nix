{pkgs, ...}: {
  programs.steam.enable = true;
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gamemode
    lutris
    polymc
    jdk8
    jdk
    vulkan-tools
    wine
    wine64
  ];
}
