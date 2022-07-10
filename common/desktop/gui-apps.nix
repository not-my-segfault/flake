{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord
    firefox
    libreoffice
    skypeforlinux
    spotify
    thunderbird
  ];
  services.flatpak.enable = true;
  xdg.portal.enable = true;
}
