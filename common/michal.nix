{ pkgs, ... }: {

  nixpkgs.config = {
    allowUnfree = true;
  };

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

  home.file.".xonshrc".text = ''
    # INIT AND ENVVARS
    import os
    xontrib load bashisms abbrevs
    
    source-bash ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    
    $PROMPT              = '{BOLD_GREEN}{short_cwd}{RESET}> '
    $BOTTOM_TOOLBAR      = '{INVERT_WHITE} {localtime} | {user}@{hostname} | {cwd} {RESET}'
    $EDITOR              = 'vim'
    $PAGER               = 'less'
    $PF_INFO             = 'ascii title os host kernel uptime memory palette'
    $SSH_AUTH_SOCK       = '/run/user/1000/gnupg/S.gpg-agent.ssh'
    $GPG_TTY             = $(tty)
    
    # SPECIFIC XONSH CONFIG
    $COMPLETIONS_CONFIRM = True
    
    # ALIASES
    aliases['cd']        = "z"
    aliases['ls']        = "exa -la @($args) --colour=always | bat --style=numbers"
    aliases['crs']       = "distrobox-enter --name crystal"
    aliases['cat']       = "bat"
    aliases['find']      = "fd"
    aliases['clear']     = "/run/current-system/sw/bin/clear && pfetch"
     
    # ABBREVS
    abbrevs['nix-shell'] = "nix-shell --run xonsh"
    
    # ZOXIDE
    execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')
    
    # GENERAL STUFF TO RUN
    gpg-connect-agent updatestartuptty /bye > /dev/null
    clear
  '';

  home.packages = with pkgs; [
    ark
    audacity
    bat
    bitwarden
    curl
    discord
    dragon
    duf
    elisa
    exa
    fd
    ffmpeg
    flameshot
    gimp
    git
    htop
    httpie
    k3b
    kate
    kcharselect
    kgpg
    kstars
    libreoffice
    microsoft-edge-dev
    ncdu
    neofetch
    pfetch
    shotwell
    thunderbird
    tldr
    vim
    wget
    xonsh
    zoxide
  ];

}
