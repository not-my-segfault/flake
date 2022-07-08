{ pkgs, ... }:

let
  wiki = {
    name = "Crystal Linux Wiki";
    domain = "wiki.getcryst.al";
    admin = "michal@tar.black";
    passwdPath = "/secret";
    useSsl = false;
    listenAddress = "10.0.0.16";
    port = 8080;
    color = "#a900ff";
  };
in
{
  services.mediawiki = {
    enable = true;
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
      
      # Theme customisation
      $wgCitizenThemeColor = '${wiki.color}';
      $wgCitizenManifestThemeColor = '${wiki.color}';
      $wgCitizenManifestBackgroundColor = '${wiki.color}';
    '';
    extensions = {
      blueSpice = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/BlueSpiceFoundation-REL1_35-ab8191a.tar.gz";
        sha256 = "hqj4jwQIkAdQ9S+q6/h4G1YvdbtLLa/MpSsk03fzerw=";
      };
      extJSBase = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/ExtJSBase-REL1_38-eeb8042.tar.gz";
        sha256 = "";
      };
      ooJSPlus = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/OOJSPlus-REL1_35-2167b81.tar.gz";
        sha256 = "0GCGucjopHugMdI8T7rtkxigiWxyTNUwgPPSC9OsDQo=";
      };
    };
    skins = {
      citizen = pkgs.fetchzip {
        url = "https://github.com/StarCitizenTools/mediawiki-skins-Citizen/archive/refs/tags/v1.17.7.zip";
        sha256 = "RNPWCJ8UtmNjch6moBLAPQyRRZHZ3q1W4DosavcyRK4=";
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
