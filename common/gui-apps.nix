{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        bitwarden
        discord
        flameshot
        libreoffice
        microsoft-edge-dev
        obs-studio
        skypeforlinux
        thunderbird
        wine
        wine64
    ]
}