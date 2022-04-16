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
    distrobox
    gnumake
    virt-manager
    vscode-fhs
    qmk
  ];

}
