{pkgs, ...}: let
  runner = {
    owner = "https://github.com/crystal-linux";
    name = "New Ewok";
    tokenFile = "/secrets/ghr-token";
    extraLabels = ["Aarch64" "NixOS"];
    extraPackages = with pkgs; [];
  };
in {
  services.github-runner = {
    enable = true;
    inherit name url tokenFile extraLabels extraPackages;
  };
}
