{ pkgs, ... }:

let
  editor = {
    package = pkgs.helix;
    alias = "hx";
  };
in {
  programs = {
    fish = {
      enable = true;
      functions = { 
        fish_greeting = "";
        pfetch = ''
          set PF_INFO "ascii title os host kernel uptime memory palette"
          if test -f /usr/bin/pfetch
            /usr/bin/pfetch
          else
            env pfetch
          end  
        '';
      };
      shellAliases = {
        cat = "bat";
        cd = "z";
        clear = "env clear && pfetch";
        crs = "distrobox-enter --name crystal -- fish";
        find = "fd";
        ls = "lsd -A";
        vi = "${editor.alias}";
        vim = "${editor.alias}";
        nvim = "${editor.alias}";
      };
      shellAbbrs = { nix-shell = "nix-shell --run fish"; };
      shellInit = ''
        set DIRENV_LOG_FORMAT ""
        set EDITOR "${editor.alias}"
        
        set -x HOSTNAME (hostname)

        if [ "$HOSTNAME" = "windows-station" ] || [ "$HOSTNAME" = "nixos-wsl" ]
          bass source ~/.wsl-yubikey
        else
          set SSH_AUTH_SOCK /run/user/1000/gnupg/S.gpg-agent.ssh
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
  };

  home.packages = with pkgs; [
    bat
    duf
    fd
    python
    lsd
    pfetch
    zoxide

    editor.package
  ];
}
