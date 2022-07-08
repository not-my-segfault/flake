{ pkgs, ... }:

let
  runner = {
    owner = "https://github.com/crystal-linux";
    name = "New Ewok";
    tokenPath = "/secrets/ghr-token";
    packages = with pkgs; [ ];
    labels = [ "Aarch64" "NixOS" ];
  };
in
{
  services.github-runner = {
    enable = true;
    name = runner.name;
    url = runner.owner;
    tokenFile = runner.tokenPath;
    extraLabels = runner.labels;
    extraPackages = runner.packages;
  };
}