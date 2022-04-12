{ pkgs, ... }:

{

  users.users.michal = {
    description = "Michal";
    shell = pkgs.xonsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo = {
    extraConfig = "Defaults pwfeedback";
  };

  services = {
    mullvad-vpn.enable = true;
    flatpak.enable = true;
  };

}
