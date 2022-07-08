{ ... }:

let
  repo = {
    url = "uk.repo.getcryst.al";
    localPath = "/var/www/crystal-mirror";
    rsyncKeys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPEDRyDWDPwXX8VRUO0EjJuxsYrM+QUb+buj02DoAoLS builder@falcon"
    ];
    internalPort = 8081;
  };
in
{
  services.httpd = {
    enable = true;
    virtualHosts = {
      "${repo.url}" = {
        listen = repo.internalPort;
        documentRoot = repo.localPath;
      };
    };
  };
    
  users.users.wwwrun = {
    openssh.authorizedKeys.keys = repo.rsyncKeys;
  };
}