{ ... }:

let
  secretPath = "/secret";
  gitlabPort = 80;
  gitlabHost = "git.nixos.local";
  httpsEnabled = false;
  adminEmail = "michal@tar.black";
in {

  services.gitlab = {
    enable = true;
    port = gitlabPort;
    host = gitlabHost;
    https = httpsEnabled;
    secrets = {
      secretFile = secretPath;
      otpFile = secretPath;
      jwsFile = secretPath;
      dbFile = secretPath;
    };
    initialRootEmail = adminEmail;
    initialRootPasswordFile = secretPath;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    virtualHosts."${gitlabHost}" = {
      enableACME = httpsEnabled;
      forceSSL = httpsEnabled;
      locations."/" = {
        proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
    };
  };

  networking = { firewall.allowedTCPPorts = [ 22 gitlabPort ]; };

}
