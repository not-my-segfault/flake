{ pkgs, ... }:

{

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    libvirtd.enable = true;
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
