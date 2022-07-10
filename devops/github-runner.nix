{pkgs, ...}: let
  runner = {
    owner = "https://github.com/crystal-linux";
    name = "new-ewok";
    tokenFile = "/secrets/ghr-token";
    extraLabels = ["Aarch64" "NixOS"];
    extraPackages = with pkgs; [];
  };
in
  with runner; {
    services.github-runner = {
      enable = true;
      inherit name url tokenFile extraLabels extraPackages;
    };
  }
