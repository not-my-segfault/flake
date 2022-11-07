{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  nix = {
    settings = {auto-optimise-store = true;};
    gc = {
      automatic = true;
      dates = "19:00";
      persistent = true;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.autoUpgrade = {
    enable = false;
    flake = "https://git.tar.black/michal/nixos-flake?rev=main";
    dates = "daily";
  };
}
