{ pkgs, lib, ... }:

{

  users.users.michal = {
    description = "Michal";
    shell = lib.mkDefault pkgs.xonsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo = { extraConfig = "Defaults pwfeedback"; };

  environment.systemPackages = with pkgs; [ firefox thunderbird ];

}
