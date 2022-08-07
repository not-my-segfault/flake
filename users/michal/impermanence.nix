{
  home.persistence."/nix/persist/home/michal" = {
    directories = [
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".gnupg"
      ".local/share/keyring"
      ".local/share/direnv"
    ];
    allowOther = true;
  };
}
