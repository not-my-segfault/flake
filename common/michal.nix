{ pkgs, ... }:

let
  editor = "hx";
in
{

  nixpkgs.config = { allowUnfree = true; };

  programs = {
    fish = {
      enable = true;
      functions = {
        fish_greeting = "";    
      };
      shellAliases = {
        cat = "bat";
        cd = "z";
        clear = "env clear && pfetch";
        crs = "distrobox-enter --name crystal -- fish";
        find = "fd";
        ls = "lsd -A";
        vi = "${editor}";
        vim = "${editor}";
        nvim = "${editor}";
        pfetch = "PF_INFO=\"ascii title os host kernel uptime memory palette\" env pfetch";
      };
      shellAbbrs = {
        nix-shell = "nix-shell --run fish";
      };
      shellInit = ''
        set DIRENV_LOG_FORMAT ""
        set EDITOR "hx"
        
        set -e fish_greeting
        set -x HOSTNAME (hostname)
        
        if [ "$HOSTNAME" = "windows-station" ] || [ "$HOSTNAME" = "nixos-wsl" ]
          bass source ~/.wsl-yubikey
        end
      '';
      interactiveShellInit = "clear";
      plugins = [
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "d715de0a2ab4e33f202d30f5c6bd8da9cfc6c310";
            sha256 = "6ys1SEfcWO0cRRNawrpnUU9tPJVVZ0E6RcPmrE9qG5g=";
          };
        }
        
        {
          name = "bass";
          src = pkgs.fetchFromGitHub {
            owner = "edc";
            repo = "bass";
            rev = "2fd3d2157d5271ca3575b13daec975ca4c10577a";
            sha256 = "fl4/Pgtkojk5AE52wpGDnuLajQxHoVqyphE90IIPYFU=";
          };
        }
        
        {
          name = "sponge";
          src = pkgs.fetchFromGitHub {
            owner = "andreiborisov";
            repo = "sponge";
            rev = "dcfcc9089939f48b25b861a9254a39de8e9f33a0";
            sha256 = "+GGfFC/hH7A8n9Wwojt5PW96fSzvRhThnZ3pLeWEqds=";
          };
        }
      ];
    };
      
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
      
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  
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
  };
  
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    sshKeys = [ "6D3C4AD0688B00F9283C6AF6A0AD05622E61D340" ];
    pinentryFlavor = "qt";
  };
  
  home.file.".wsl-yubikey".text = ''
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
      rm -f "$SSH_AUTH_SOCK"
      wsl2_ssh_pageant_bin="/mnt/c/Users/micha/wsl2-ssh-pageant.exe"
      if test -x "$wsl2_ssh_pageant_bin"; then
        (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
      else
        echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
      fi
      unset wsl2_ssh_pageant_bin
    fi

    export GPG_AGENT_SOCK="/run/user/$UID/gnupg/S.gpg-agent"
    if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
      rm -rf "$GPG_AGENT_SOCK"
        socat UNIX-LISTEN:"/run/user/$UID/gnupg/S.gpg-agent",fork EXEC:'/mnt/c/Users/micha/npiperelay.exe -ei -ep -s -a "C:/Users/micha/AppData/Roaming/gnupg/S.gpg-agent"',nofork > /dev/null 2>&1 &
    fi
  '';

  xdg.configFile."sway/config".source = ./sway.conf;

  home.packages = with pkgs; [
    bat
    duf
    fd
    htop
    ncdu
    neofetch
    onefetch
    w3m
    python
    lsd
    pfetch
    zoxide
    helix
  ];

  home.stateVersion = "22.05";

}
