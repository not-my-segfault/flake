{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    helm
  ];

  services.flatpak.enable = true;

}
