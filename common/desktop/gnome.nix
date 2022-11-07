{pkgs, ...}: {
  services.xserver = {
    enable = true;
    layout = "us";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    caffeine
    containers
    grand-theft-focus
    gsconnect
    rounded-window-corners
    space-bar
    tiling-assistant
    tophat
    appindicator
    dash-to-panel
    pano
  ];
}
