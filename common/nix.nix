{

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
			auto-optimise-store = true;
		};
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

	system.autoUpgrade = {
		enable = true;
		flake = "https://git.tar.black/michal/nixos-flake?rev=main";
		dates = "daily";
	};

}
