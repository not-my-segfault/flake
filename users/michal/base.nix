{pkgs, ...}: {
  nixpkgs.config = {allowUnfree = true;};

  home = {
    username = "michal";
    homeDirectory = "/home/michal";
    packages = with pkgs; [neofetch ncdu];
    stateVersion = "22.11";
  };
}
