{ pkgs, ... }:

{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        sway-contrib.grimshot
        sway-contrib.inactive-windows-transparency
        wl-clipboard
        mako
        foot
        wofi
      ];
    };
    qt5ct.enable = true;
    xwayland.enable = true;
  };

  qt5.style = "adwaita-dark";

  environment = {
    systemPackages = with pkgs; [
      polkit_gnome
      gnome-themes-extra
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
      adwaita-qt
      gnome.adwaita-icon-theme
      jq
    ];
    pathsToLink = [ "/libexec" ];
    sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };

}
