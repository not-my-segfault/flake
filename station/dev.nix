{ pkgs, ... }:

{

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs; [
    distrobox
    gnumake
    vscode-fhs
    qmk
  ];

}
