{ pkgs, ... }:

{

  services = {
    udev.packages = with pkgs; [
      yubikey-personalization
      qmk-udev-rules
    ];
    pcscd.enable = true;
  };

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
    control = "sufficient";
  };

  environment.systemPackages = with pkgs; [
    yubico-pam
    yubikey-manager
    yubikey-manager-qt
  ];

}
