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
    xwayland.enable = true;
  };

	qt5.style = "adwaita-dark";

  environment = {
    systemPackages = with pkgs; [ 
      polkit_gnome
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
			adwaita-qt
			gnome.adwaita-icon-theme
      jq
    ];
    pathsToLink = [ "/libexec" ];
    variables = rec {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };

}
