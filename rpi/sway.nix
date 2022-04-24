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

  environment = {
    systemPackages = with pkgs; [ 
      polkit_gnome
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
    ];
    pathsToLink = [ "/libexec" ];
    variables = rec {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };

}
