{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    helm
    sonic-pi
  ];

}
