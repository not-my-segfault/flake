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

  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
  ];

}
