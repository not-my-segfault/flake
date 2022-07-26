{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      userName = "Michal";
      userEmail = "michal@tar.black";
      signing = {
        key = "A6A1A4DCB22279B9";
        signByDefault = true;
      };
      extraConfig = {
        core.editor = "flatpak run --file-forwarding re.sonny.Commit @@";
        safe.directory = "*";
      };
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

    fish = {
      functions = {
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
      shellAliases = {
        crs = "distrobox-enter --name crystal -- fish";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableScDaemon = true;
      sshKeys = ["6D3C4AD0688B00F9283C6AF6A0AD05622E61D340"];
      pinentryFlavor = "gnome3";
    };
  };

  home = {
    file = {
      ".wsl-yubikey".source = ./configs/.wsl-yubikey;
      ".ssh/authorized_keys".text = ''
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAwgkEpWmDGQiOK+N5MxXdBYDIIr6DNn52UAKqY0dnxyYw1aATyChe1etqeWN/e6DH6g9yc3BvG6lV21pCVmqc3CyrxfsgQnCBU8ziUi8xk9dmdbSyZoEnETY2DGX3oWmYOlNQsbSa8IBa4iwbW5lLpdvowaka9TEmTGsNafkx8fPMhK4cdD0RsAsCg1pFCskHOxBZzrgV5HL2aMLy2Ys+4DqWOPXIY3pXsVjzdi3YVW59oXaNNd+NC8pqM3HiR2X4WS+/F5s1yIJE8G7TeC7mSqa68K6pfPAjzyHe/4ZzcyYkuOEe4KSxsPwNGGCXoYEaCMb2v7jgxWWZxedvBC1psSiFj01AAZBWl2fwSIOa88LwGtdtA/LOz5aOdHmxtZ8NwwGtx+mWz31eWUEMUEc72XMn7XdP++yvdlVsZg+bat2NryjO8+iCpz8opfqZ9r5f4EDkXFPcFMMwjUAFUUk0hv008vwhuudEwcuqgFzyt23aWOQFxTVAtD4OHYvKYCF1JkVYuZnpzDY2I2zUZ+749kYyUm+aWae+fE54FvyX0yO3M08GNizUn0X578HhICgZJlo09ewy9dIKQtsoVZPFGyr+jDqJJkJFbCkLwwxUIiijz16olrFD3UpscF+oiEVzkJ+9ClXvcbArqu1KtZ+2TrjFhk1o23ukmxZrjSEKkQ== cardno:16 179 196
      '';
      ".ssh/config".text = ''
        Host michal@falcon
          HostName repo.getcryst.al
          User michal

        Host builder@falcon
          HostName repo.getcryst.al
          User builder

        Host admin@tar
          HostName 10.0.0.16
          User admin

        Host michal@new-ewok
          HostName 10.0.0.15
          User michal

        Host michal@new-ewok
          HostName 10.0.0.15
          User root
        
        ControlMaster auto
        ControlPath /tmp/%r@%h:%p
        ControlPersist yes
      '';
    };
    packages = with pkgs; [
      gitui
      onefetch
      qmk
      sshs
      w3m
    ];
  };
}
