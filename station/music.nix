{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [    zrythm
  ];

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-";    value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-";    value = "95"; }
    { domain = "@audio"; item = "nofile";  type = "soft"; value = "4096000"; }
    { domain = "@audio"; item = "nofile";  type = "hard"; value = "4096000"; }
  ];

}