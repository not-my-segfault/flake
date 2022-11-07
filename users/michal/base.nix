{pkgs, ...}: {
  nixpkgs.config = {allowUnfree = true;};

  home = {
    username = "michal";
    homeDirectory = "/home/michal";
    stateVersion = "22.11";
  };
}
