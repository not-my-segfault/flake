{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      userName = "Michal";
      userEmail = "michal@tar.black";
    };

    gpg = {
      enable = true;
      scdaemonSettings = {
        card-timeout = "5";
        disable-ccid = true;
        reader-port = "Yubico Yubikey";
      };
      settings = {
        trust-model = "tofu+pgp";
        default-key = "A6A1A4DCB22279B9";
      };
    };

    fish.functions = {
      __onefetch_on_pwd_change = {
        body = "__onefetch_on_pwd_change --on-variable PWD";
        onEvent = ''
          if test -d ./.git
            if test -e ./logo.png
              onefetch --image logo.png
            else
              onefetch
            end
          end
        '';
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableScDaemon = true;
      sshKeys = [ "" ];
      pinentryFlavor = "qt";
    };
  };

  home = {
    file.".wsl-yubikey".source = ./configs/.wsl-yubikey;
    packages = with pkgs; [ onefetch w3m ];
  };
}
