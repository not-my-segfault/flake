{

  description = "Michal's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    hm-configs.url = "github:ihatethefrench/hm-flake";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, nixos-wsl, hm-configs, ... }@inputs:

  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in
  {
    devShell = forAllSystems (system:
      let pkgs = nixpkgsFor.${system};
      in pkgs.mkShell {
        buildInputs = with pkgs; [ nix-linter statix nixfmt ];
      }
    );
    
    homeConfigurations.michal = forAllSystems (system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ 
          ./michal/shell.nix 
          ./michal/dev.nix 
          ./michal/base.nix
        ];
      };
    );
      
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
#       ./rpi/media.nix
        ./rpi/personal.nix
#       ./rpi/sway.nix

#       ./server/mc-server.nix
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
