{ pkgs, ... }:

{

  nixpkgs.config = { allowUnfree = true; };

  programs.git = {
    enable = true;
    userName = "Michal";
    userEmail = "michal@tar.black";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    sshKeys = [ "6D3C4AD0688B00F9283C6AF6A0AD05622E61D340" ];
    pinentryFlavor = "qt";
  };

  programs.gpg = {
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

  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };
  };

  home.file.".xonshrc".text = ''
    # INIT AND ENVVARS
    import os,platform
    xontrib load bashisms abbrevs direnv gitinfo

    source-bash /etc/profile

    $BOTTOM_TOOLBAR               = '{INVERT_WHITE} {localtime} | {user}@{hostname} | {cwd} {RESET}'
    $EDITOR                       = 'hx'
    $GPG_TTY                      = $(tty)
    $PAGER                        = 'less'
    $PF_INFO                      = 'ascii title os host kernel uptime memory palette'
    $PROMPT                       = '{BOLD_GREEN}{short_cwd}{RESET}> '
    $DIRENV_LOG_FORMAT            = ""
    $THEFUCK_REQUIRE_CONFIRMATION = True

    # SPECIFIC XONSH CONFIG
    $COMPLETIONS_CONFIRM          = True

    # ALIASES
    aliases['cat']                = "bat"
    aliases['cd']                 = "z"
    aliases['clear']              = "env clear && pfetch"
    aliases['crs']                = "distrobox-enter --name crystal -- xonsh"
    aliases['find']               = "fd"
    aliases['fuck']               = lambda args, stdin=None: execx($(thefuck $(history -1)))
    aliases['ls']                 = "lsd -A"
    
    # ABBREVS
    abbrevs['nix-shell']          = "nix-shell --run xonsh"

    # ZOXIDE
    execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')

    # PLATFORM SPECIFIC STUFF
    if platform.node() == 'nixos-station' || platform.node() == 'nixos-laptop':
      $SSH_AUTH_SOCK = '/run/user/1000/gnupg/S.gpg-agent.ssh'
      
    if platform.node() == 'windows-station' || platform.node() = 'nixos-wsl':
      source-bash ~/.wsl-yubikey

    # GENERAL STUFF TO RUN
    gpg-connect-agent updatestartuptty /bye > /dev/null
    clear
  '';
  
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
    
    export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
    if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
      rm -rf "$GPG_AGENT_SOCK"
      wsl2_ssh_pageant_bin="/mnt/c/Users/micha/wsl2-ssh-pageant.exe"
      if test -x "$wsl2_ssh_pageant_bin"; then
        (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
      else
        echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
      fi
      unset wsl2_ssh_pageant_bin
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
    lsd
    pfetch
    thefuck
    xonsh
    zoxide
    hx
  ];

  home.stateVersion = "22.05";

}
