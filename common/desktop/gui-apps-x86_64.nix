{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord
    skypeforlinux
    spotify
  ];
}
