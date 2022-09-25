{pkgs, ...}: let
  editor = {
    package = pkgs.helix;
    alias = "hx";
  };
in {
  programs = {
    nushell = {
      enable = true;
      configFile.text = ''
        let-env config = {
          edit_mode: vi
          rm_always_trash: true
          completion_algorithm: fuzzy
          show_banner: false
          
          hooks : {
            pre_prompt: [{
              code: "
                let direnv = (direnv export json | from json)
                let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
                $direnv | load-env
              "
            }]
          }
        }
        alias cat = bat
        alias vim = ${editor.alias}
        alias htop = btm
        alias ul = ultralist
        alias nix-shell = nix-shell --run nu
                
        source ~/.cache/nu/zoxide.nu
        source ~/.cache/nu/starship.nu
        
        alias cd = z
      '';
      envFile.text = ''
        let-env DIRENV_LOG_FORMAT = ""
        let-env EDITOR = "${editor.alias}"
        let-env QMK_HOME = "/hdd/Git/personal/qmk_firmware"
        let-env QMK_FIRMWARE = "/hdd/Git/personal/qmk_firmware"
        let-env SHELL = "/home/michal/.nix-profile/bin/nu"
        let-env SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket | str trim)
        let-env PATH = ("/home/michal/.cargo/bin:" + $env.PATH)

        mkdir ~/.cache/nu
        zoxide init nushell --hook prompt | save ~/.cache/nu/zoxide.nu
        starship init nu | save ~/.cache/nu/starship.nu
      '';
    };
    starship = {
      enable = true;
      settings = {
        command_timeout = 5000;
        add_newline = false;
        character.disabled = true;
        time = {
          disabled = false;
          format = "[$time]($style)";
        };
        fill.symbol = " ";
        git_status = {
          ahead = "⇡\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          behind = "⇣\${count}";
        };
        format = "$all$fill$time$line_break";
      };
    };
    fzf = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };

  home = {
    file.".wezterm.lua".source = ./configs/.wezterm.lua;
    packages = with pkgs; [
      asciinema
      bat
      bottom
      duf
      fd
      lsd
      ultralist
      zellij
      zoxide

      editor.package
    ];
  };
}
