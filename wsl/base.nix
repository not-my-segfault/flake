{ pkgs, ... }:

{
    networking.hostName = "nixos-wsl";
    system.stateVersion = "21.11";
    
    environment.systemPackages = with pkgs; [
      jetbrains.clion
    ];
}
