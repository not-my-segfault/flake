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
        
        source ~/.cache/nu/zoxide.nu
        source ~/.cache/nu/starship.nu
      '';
      envFile.text = ''
        let-env DIRENV_LOG_FORMAT = ""
        let-env EDITOR = "${editor.alias}"
        let-env QMK_HOME = "/hdd/Git/personal/qmk_firmware"
        let-env QMK_FIRMWARE = "/hdd/Git/personal/qmk_firmware"
        let-env SHELL = "${pkgs.nushell.out}/bin/nu"
        let-env SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket | str trim)

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
        format = "$all\n";
      };
    };
    fzf = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
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
}
