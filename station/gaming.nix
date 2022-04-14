{ pkgs, ... }:

{

  programs.steam.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    microsoft-edge-dev
    gamemode
    lutris
    polymc
    vulkan-tools
  ];

}
