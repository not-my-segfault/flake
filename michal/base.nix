{ pkgs, ... }:

{
  nixpkgs.config = { allowUnfree = true; };

  home = {
    packages = with pkgs; [ neofetch htop ncdu ];

    stateVersion = "22.05";
  };
}
