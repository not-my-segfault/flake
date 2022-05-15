{ pkgs, ... }:

let
  secretPath = "/hdd/secret";
  gitlabPort = 8080;
  gitlabHost = "git.nixos.local";
  httpsEnabled = false;
  adminEmail = "michal@tar.black";
in
{

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
    extraGitlabRb = ''
      nginx['enable'] = false
      puma['port'] = ${toString (gitlabPort + 1)}
      gitlab_workhorse['auth_backend'] = "http://localhost:${toString (gitlabPort + 1)}"
      external_url = "http://127.0.0.1:${toString gitlabPort}"
    '';
    initialRootEmail = adminEmail;
    initialRootPasswordFile = secretPath;
  };

  services.nginx = {
    enable = true;
    user = "gitlab";
    recommendedProxySettings = true;
    virtualHosts."${gitlabHost}" = {
      locations."/" = {
#       proxyPass = "http://unix:/var/gitlab/state/tmp/sockets/gitlab.socket";
        proxyPass = "http://127.0.0.1:${toString gitlabPort}$request_uri";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nodePackages.npm
    nodePackages.yarn
    nodejs
  ];

  networking = {
    firewall.allowedTCPPorts = [
      22
      gitlabPort
    ];
    hosts = {
      "127.0.0.1" = [ gitlabHost ];
    };
  };

}
