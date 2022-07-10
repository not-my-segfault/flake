{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord
    firefox
    libreoffice
    skypeforlinux
    spotify
    thunderbird
  ];
}
