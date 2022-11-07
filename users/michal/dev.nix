{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      userName = "Michal";
      userEmail = "michal@tar.black";
      signing = {
        key = "C9CBDADE150C1E8B";
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
        default-key = "C9CBDADE150C1E8B";
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
      enableScDaemon = false;
      sshKeys = ["2E7B7CF23ACC452292F1C0745221D5D912086906"];
      pinentryFlavor = "gnome3";
    };
  };

  home = {
    file = {
      ".ssh/config".text = ''
        Host Falcon Admin
          HostName falcon.repo.getcryst.al
          User michal

        Host Falcon Builder
          HostName falcon.repo.getcryst.al
          User builder

        Host Tar Admin
          HostName tar.black
          User admin

        Host Bellator Admin
          HostName admin@getcryst.al
          User admin

        Host Antiz Admin
          HostName antiz.rc-linux.com
          User michal
          Port 2224
      '';
    };
    packages = with pkgs; [
      sshs
    ];
  };
}
