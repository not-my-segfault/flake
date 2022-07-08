{ pkgs, ... }:

let
  repo = {
    url = "uk.repo.getcryst.al";
    localPath = "/var/www/crystal-mirror";
    rsyncKeys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPEDRyDWDPwXX8VRUO0EjJuxsYrM+QUb+buj02DoAoLS builder@falcon"
    ];
    listenUrl = "*";
    listenPort = 8081;
  };
in
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "${repo.url}" = {
        listen = [
          {
            addr = repo.listenUrl;
            port = repo.listenPort;
          }
        ];
        root = repo.localPath;
        extraConfig = ''
          autoindex on;
        '';
      };
    };
  };
    
  users.users.reposync = {
    shell = pkgs.bash;
    isNormalUser = true;
    openssh.authorizedKeys.keys = repo.rsyncKeys;
    packages = with pkgs; [ rsync ];
  };
    
  networking.firewall = {
    allowedTCPPorts = [ repo.listenPort ];  
  };
}