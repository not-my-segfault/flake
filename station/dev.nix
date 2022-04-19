{ pkgs, ... }:

{

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    libvirtd.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    distrobox
    git
    gnumake
    htop
    vim
    virt-manager
    vscode-fhs
    qmk
  ];

}
