{pkgs, ...}: let
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
        clear = "env clear && pfetch && ultralist list";
        find = "fd";
        vi = "${editor.alias}";
        vim = "${editor.alias}";
        nvim = "${editor.alias}";
        htop = "btm";
        ul = "ultralist";
        f = "fuck";
      };
      shellAbbrs = {nix-shell = "nix-shell --run fish";};
      shellInit = ''
        set DIRENV_LOG_FORMAT ""
        set EDITOR "${editor.alias}"

        set -x HOSTNAME (hostname)

        set SSH_AUTH_SOCK (gpgconf --list-dirs | grep ssh | cut -d: -f2)
      '';
      interactiveShellInit = ''
        thefuck --alias | source
        clear
      '';
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

        {
          name = "fish-plugin-sudo";
          src = pkgs.fetchFromGitHub {
            owner = "eth-p";
            repo = "fish-plugin-sudo";
            rev = "e153fdea568cd370312f9c0809fac15fc7582bfd";
            sha256 = "bTK34G+J6AOoYmhOIG0XNXV2SN/u789+epXMBN3lnu4=";
          };
        }

        {
          name = "puffer-fish";
          src = pkgs.fetchFromGitHub {
            owner = "nickeb96";
            repo = "puffer-fish";
            rev = "df333fff5130ef8bf153c9bafbf0661534f81d9c";
            sha256 = "VtFrRzI476Hkutwwgkkc9hoiCma6Xyknm7xHeghrLxo=";
          };
        }
      ];
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    lsd = {
      enable = true;
      enableAliases = true;
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
    thefuck
    ultralist
    zellij
    bottom

    editor.package
  ];
}
