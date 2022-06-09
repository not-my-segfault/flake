{ pkgs, ... }:

{

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    distrobox
    htop
    okteta
    qbittorrent
    virt-manager
  ];

}
