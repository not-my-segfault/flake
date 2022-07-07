{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitwarden
    discord
    flameshot
    libreoffice
    microsoft-edge-dev
    obs-studio
    okteta
    qbittorrent
    skypeforlinux
    thunderbird
    virt-manager
    wine
    wine64
  ];
}
