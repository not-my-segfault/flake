{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "mode=755"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/NIX";
      options = ["compress=zstd"];
    };
  };

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib"
    ];
  };

  programs.fuse.userAllowOther = true;
}
