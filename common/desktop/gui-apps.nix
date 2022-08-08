{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice
    thunderbird
  ];
  services.flatpak.enable = true;
  xdg.portal.enable = true;
}
