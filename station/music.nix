{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [    
    zrythm
#   surge
    zam-plugins
    geonkick
    x42-plugins
    helm
    distrho
  ];

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-";    value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-";    value = "95"; }
    { domain = "@audio"; item = "nofile";  type = "soft"; value = "4096000"; }
    { domain = "@audio"; item = "nofile";  type = "hard"; value = "4096000"; }
  ];

}
