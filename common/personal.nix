{ pkgs, ... }:

{

  users.users.michal = {
    description = "Michal";
    shell = pkgs.xonsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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
