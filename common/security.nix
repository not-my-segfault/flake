{pkgs, ...}: {
  systemd.coredump.enable = false;

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      firefox = {
        executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };
      thunderbird = {
        executable = "${pkgs.lib.getBin pkgs.thunderbird}/bin/thunderbird";
        profile = "${pkgs.firejail}/etc/firejail/thunderbird.profile";
      };
    };
  };

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  security.apparmor = {
    enable = true;
    enableCache = true;
  };

  services.dbus.apparmor = "enabled";
}
