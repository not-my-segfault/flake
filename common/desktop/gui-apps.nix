{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
  ];
  services.flatpak.enable = true;
  xdg.portal.enable = true;
}
