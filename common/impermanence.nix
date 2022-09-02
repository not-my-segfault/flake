{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "mode=755"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/PERSIST";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/PERSIST";
      fsType = "btrfs";
      options = ["subvol=@boot"];
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