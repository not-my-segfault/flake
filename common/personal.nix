{ pkgs, lib, ... }:

{

  users.users.michal = {
    description = "Michal";
    shell = lib.mkDefault pkgs.xonsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" ];
  };

  security.sudo = { extraConfig = "Defaults pwfeedback"; };

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
  ];

}
