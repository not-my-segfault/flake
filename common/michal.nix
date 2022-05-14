{ pkgs, ... }:

{

  nixpkgs.config = { allowUnfree = true; };

  programs.git = {
    enable = true;
    userName = "Michal";
    userEmail = "michal@tar.black";
    signing = {
      key = "A6A1A4DCB22279B9";
      signByDefault = true;
    };
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

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ copilot-vim rainbow vim-gitgutter ];
    settings = {
      number = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };
  };

  home.file.".xonshrc".text = ''
    # INIT AND ENVVARS
    import os
    xontrib load bashisms abbrevs direnv gitinfo

    source-bash /etc/profile

    $BOTTOM_TOOLBAR               = '{INVERT_WHITE} {localtime} | {user}@{hostname} | {cwd} {RESET}'
    $EDITOR                       = 'vim'
    $GPG_TTY                      = $(tty)
    $PAGER                        = 'less'
    $PF_INFO                      = 'ascii title os host kernel uptime memory palette'
    $PROMPT                       = '{BOLD_GREEN}{short_cwd}{RESET}> '
    $SSH_AUTH_SOCK                = '/run/user/1000/gnupg/S.gpg-agent.ssh'
    $DIRENV_LOG_FORMAT            = ""
    $THEFUCK_REQUIRE_CONFIRMATION = True

    # SPECIFIC XONSH CONFIG
    $COMPLETIONS_CONFIRM = True

    # ALIASES
    aliases['cat']                = "bat"
    aliases['cd']                 = "z"
    aliases['clear']              = "env clear && pfetch"
    aliases['crs']                = "distrobox-enter --name crystal"
    aliases['find']               = "fd"
    aliases['fuck']               = lambda args, stdin=None: execx($(thefuck $(history -1)))
    aliases['ls']                 = "exa -la @($args) --colour=always | bat --style=numbers"
     
    # ABBREVS
    abbrevs['nix-shell'] = "nix-shell --run xonsh"

    # ZOXIDE
    execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')

    # GENERAL STUFF TO RUN
    gpg-connect-agent updatestartuptty /bye > /dev/null
    clear
  '';

  xdg.configFile."sway/config".source = ./sway.conf;

  home.packages = with pkgs; [
    bat
    duf
    exa
    fd
    htop
    ncdu
    neofetch
    nodejs-slim
    pfetch
    thefuck
    xonsh
    zoxide
  ];

}
