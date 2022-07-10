{pkgs, ...}: let
  wiki = {
    name = "Crystal Linux Wiki";
    domain = "wiki.getcryst.al";
    admin = "michal@tar.black";
    passwdPath = "/secret";
    useSsl = false;
    listenAddress = "*";
    port = 80;
    color = "#a900ff";
    logoPath = ./logo.png;
  };
in {
  services.mediawiki = {
    enable = true;
    inherit name;
    virtualHost = {
      hostName = wiki.domain;
      adminAddr = wiki.admin;
      listen = [
        {
          ip = wiki.listenAddress;
          inherit port;
          ssl = wiki.useSsl;
        }
      ];
      locations = {
        "/logo.png" = {
          alias = wiki.logoPath;
        };
        "/favicon.ico" = {
          alias = wiki.logoPath;
        };
      };
    };
    passwordFile = wiki.passwdPath;
    extraConfig = ''
      # Disable anonymous editing
      $wgGroupPermissions['*']['edit'] = false;

      # Set theme
      wfLoadSkin( 'citizen' );
      $wgDefaultSkin = 'citizen';
      $wgLogo = 'logo.png';

      # Theme customisation
      $wgCitizenThemeColor = '${wiki.color}';
      $wgCitizenManifestThemeColor = '${wiki.color}';
      $wgCitizenManifestBackgroundColor = '${wiki.color}';
    '';
    extensions = {
      visualEditor = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/VisualEditor-REL1_37-4c4ca57.tar.gz";
        sha256 = "/BH/q+lrLkCZAaOeiL7HZvZaUKP9VA4p0S8mt7XcFXE=";
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
      db_names = ["mediawiki"];
      mailcontent = "log";
      mail_address = "null@tar.black";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [wiki.port];
  };

  environment.systemPackages = with pkgs; [
    imagemagickBig
  ];
}
