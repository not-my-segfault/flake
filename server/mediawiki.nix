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
        sha256 = "5b72bc79ca949646192c8e5fceb399ce9163bb58f4f690560571623442aced4a";
      };
    };
    skins = {
      citizen = pkgs.fetchzip {
        url = "https://github.com/StarCitizenTools/mediawiki-skins-Citizen/archive/refs/tags/v1.17.7.zip";
        sha256 = "854d7a49b87533d149a83d53975f6e3b3c9847868bdb43e5d6f10ef0bc6e3c43";
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
  
  environment.systemPackages = with pkgs; [
    imagemagickBig  
  ];
}
