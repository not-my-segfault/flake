{

  description = "Michal's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    hm-configs.url = "github:ihatethefrench/hm-flake";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, nixos-wsl, hm-configs, ... }@inputs:

    flake-utils.lib.eachDefaultSystem(system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [ nix-linter statix nixfmt ];
      };

      homeConfigurations.michal = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
          ./michal/shell.nix 
          ./michal/dev.nix 
          ./michal/base.nix
          {
            home = {
              username = "michal";
              homeDirectory = "/home/michal";
            };
          }
        ];
      };
      
      nixosConfigurations."nixos-station" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./station/base.nix
          ./station/gaming.nix
          ./station/hardware.nix
          ./station/music.nix
          ./station/qmk.nix

          ./common/dev.nix
          ./common/gui-apps.nix
          ./common/kde.nix
          ./common/media.nix
          ./common/nix.nix
          ./common/personal.nix
          ./common/yubikey.nix

        ];
      };

      nixosConfigurations."nixos-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./laptop/base.nix
          ./laptop/hardware.nix

          ./common/dev.nix
          ./common/gui-apps.nix
          ./common/kde.nix
          ./common/media.nix
          ./common/nix.nix
          ./common/personal.nix
          ./common/yubikey.nix

        ];
      };

      nixosConfigurations."nixos-wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./wsl/base.nix

          ./common/dev.nix
          ./common/nix.nix
          ./common/personal.nix
          ./common/yubikey.nix

          nixos-wsl.nixosModules.wsl
          {
            wsl.enable = true;
            wsl.automountPath = "/mnt";
            wsl.defaultUser = "michal";
            wsl.startMenuLaunchers = true;
            wsl.interop = {
              register = true;
              includePath = false;
            };
          }
        ];
      };

      nixosConfigurations."nixos-rpi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./rpi/base.nix
          ./rpi/hardware.nix
#         ./rpi/media.nix
          ./rpi/personal.nix
#         ./rpi/sway.nix

#         ./server/mc-server.nix
          ./server/gitlab.nix

          ./station/qmk.nix

          ./common/personal.nix
          ./common/nix.nix
          ./common/dev.nix
          ./common/yubikey.nix

          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
}
