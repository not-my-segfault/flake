{ pkgs, ... }:

{

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.plasma5.enable = true;
    displayManager = {
      sddm.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    ark
    kate
    kcharselect
    kgpg
    plasma-browser-integration
    sddm-kcm
  ];

}