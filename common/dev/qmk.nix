{pkgs, ...}: {
  services.udev.packages = with pkgs; [qmk-udev-rules];

  environment.systemPackages = with pkgs; [gnumake qmk];
}
