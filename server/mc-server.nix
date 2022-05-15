{ pkgs, ... }:

let
  pkgs.fabric-mc = import ./fabric-mc.nix;
in
{

  services.minecraft-server = {
    enable = true;
    package = pkgs.fabric-mc;
    eula = true;
    whitelist = {};
    serverProperties = {};
    jvmOpts = "";
  };

}


