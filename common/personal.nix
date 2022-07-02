{ pkgs, lib, ... }:

{

  users.users.michal = {
    description = "michal";
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "users" "audio" "video" "disco" ]; # hahahahahaha avd
    uid = 1000;
  };

  security.sudo = { extraConfig = "Defaults pwfeedback"; };

  environment = {
    pathsToLink = [
      "/share/fish"
    ];
    systemPackages = with pkgs; [
      home-manager
    ]
  };
}
