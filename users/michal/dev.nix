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
        Host michal@falcon.repo.getcryst.al
          HostName falcon.repo.getcryst.al
          User michal

        Host builder@falcon.repo.getcryst.al
          HostName falcon.repo.getcryst.al
          User builder

        Host admin@tar.black
          HostName tar.black
          User admin

        Host admin@getcryst.al
          HostName admin@getcryst.al
          User admin

        ControlMaster auto
        ControlPath /tmp/%r@%h:%p
        ControlPersist yes
      '';
    };
    packages = with pkgs; [
      qmk
      sshs
      lapce
    ];
  };
}
