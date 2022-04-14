{ pkgs, ... }:

{

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs; [
    distrobox
    gnumake
    virtualbox
    vscode-fhs
    qmk
  ];

}
