{ pkgs, ... }:

let
  wiki = {
    name = "Crystal Linux Wiki";
    domain = "wiki.getcryst.al";
    admin = "michal@tar.black";
    passwdPath = "/secret";
    useSsl = false;
    listenAddress = "*";
    port = 80;
    color = "#a900ff";
    logo = ./logo.png;
    packageWithLogo = pkgs.buildEnv {
      name = "mediawiki-custom";
      paths = [ pkgs.mediawiki wiki.logo ];
      inherit (pkgs.mediawiki) pname version;
    };
  };
in
{
  services.mediawiki = {
    enable = true;
    package = wiki.packageWithLogo;
    name = wiki.name;
    virtualHost = {
      hostName = wiki.domain;
      adminAddr = wiki.admin;
      listen = [
        {
          ip = wiki.listenAddress;
          port = wiki.port;
          ssl = wiki.useSsl;
        }
      ];
    };
    passwordFile = wiki.passwdPath;
    extraConfig = ''
      # Disable anonymous editing
      $wgGroupPermissions['*']['edit'] = false;
        
      # Set theme
      wfLoadSkin( 'citizen' );
      $wgDefaultSkin = 'citizen';
      $wgLogo = '/logo.png';
      
      # Theme customisation
      $wgCitizenThemeColor = '${wiki.color}';
      $wgCitizenManifestThemeColor = '${wiki.color}';
      $wgCitizenManifestBackgroundColor = '${wiki.color}';
    '';
    extensions = {};
    skins = {
      citizen = pkgs.fetchzip {
        url = "https://github.com/StarCitizenTools/mediawiki-skins-Citizen/archive/refs/tags/v1.17.7.zip";
        sha256 = "RNPWCJ8UtmNjch6moBLAPQyRRZHZ3q1W4DosavcyRK4=";
      };
      crystal-branding = pkgs.fetchzip {
        url = "https://github.com/crystal-linux/branding/archive/3caca02cc722395d26acdce44e92ac76ba9795cc.zip";
        sha256 = "RawFmLXtL8NLzg7mNDT5bQiqaWjlWk+OmpUlgGod+Hc=";
      };
    };
  };
  
  services.automysqlbackup = {
    enable = true;
    config = {
      db_names = [ "mediawiki" ];
      mailcontent = "log";
      mail_address = "null@tar.black";
    };    
  };
  
  networking.firewall = {
    allowedTCPPorts = [ wiki.port ];
  };
  
  environment.systemPackages = with pkgs; [
    imagemagickBig  
  ];
}
