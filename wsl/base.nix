{ pkgs, ... }:

{

  networking.hostName = "nixos-wsl";
  system.stateVersion = "21.11";

  environment.systemPackages = with pkgs; [ pcsclite socat ];

  security.polkit.extraConfig = ''
    
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
  '';

}
