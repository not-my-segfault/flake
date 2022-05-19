{ pkgs, ... }:

let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix/";
    rev = "26f06e415a74dc10727cf9c9a40c83b635238900";
  }) { inherit pkgs; };

  pyenv = mach-nix.mkPython {
    requirements = ''
      xonsh-direnv
      xontrib-gitinfo
    '';
    _.xonsh.buildInputs.add = [ pkgs.xonsh ];
  };

  xonsh_with_plugins = pkgs.xonsh.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs
      ++ pyenv.python.pkgs.selectPkgs pyenv.python.pkgs;
  });
in {

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

  users.users.michal.shell = xonsh_with_plugins;

}
