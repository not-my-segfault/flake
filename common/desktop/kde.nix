{pkgs, ...}: {
  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.plasma5.enable = true;
    displayManager = {sddm.enable = true;};
  };

  environment.systemPackages = with pkgs; [
    ark
    kate
    kstars
    plasma-browser-integration
    kde-gtk-config
    sddm-kcm
  ];
}
