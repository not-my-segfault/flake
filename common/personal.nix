{pkgs, ...}: {
  users.users.michal = {
    description = "michal";
    shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["wheel" "users" "audio" "video"];
    uid = 1000;
  };

  security.sudo = {extraConfig = "Defaults pwfeedback";};

  environment = {
    systemPackages = with pkgs; [home-manager];
  };
}
