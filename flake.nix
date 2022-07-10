{
  description = "Michal's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    home-manager,
    nixos-wsl,
    utils,
    ...
  } @ inputs: let
    modules = rec {
      homeCommon = [./users/michal/shell.nix ./users/michal/base.nix];
      nixosCommon = [
        ./common/nix.nix
        ./common/personal.nix
        ./common/yubikey.nix
      ];
      dev = [
        ./common/dev/distrobox.nix
        ./common/dev/qmk.nix
      ];
      desktops = {
        common = [
          ./common/desktop/media.nix
          ./common/desktop/gui-apps.nix
        ];
        kde =
          [
            ./common/desktop/kde.nix
          ]
          ++ modules.desktops.common;
        sway =
          [
            ./common/desktop/sway.nix
          ]
          ++ modules.desktops.common;
      };
      server = [
        ./devops/github-runner.nix
        ./devops/mediawiki.nix
        ./devops/soft-serve.nix
      ];
    };

    pkgs = {
      x86 = nixpkgs.legacyPackages.x86_64-linux;
      arm = nixpkgs.legacyPackages.aarch64-linux;
    };

    defaultModules = x:
      nixpkgs.lib.forEach ["base.nix" "hardware.nix"] (
        mod: (./. + "/devices" + ("/" + x) + ("/" + mod))
      );
  in {
    homeConfigurations = {
      "michal" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs.x86;
        modules = modules.homeCommon ++ [./users/michal/dev.nix];
      };

      "michal@nixos-rpi" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs.arm;
        modules = modules.homeCommon;
      };
    };

    nixosConfigurations = {
      "nixos-station" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          defaultModules "station"
          ++ modules.desktops.kde
          ++ modules.nixosCommon
          ++ modules.dev;
      };

      "nixos-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          defaultModules "laptop"
          ++ modules.desktops.kde
          ++ modules.nixosCommon;
      };

      "nixos-rpi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules =
          defaultModules "rpi"
          ++ [nixos-hardware.nixosModules.raspberry-pi-4]
          ++ modules.nixosCommon
          ++ modules.server;
      };
    };

    devShells = {
      x86_64-linux.default = pkgs.x86.mkShell {
        buildInputs = with pkgs.x86; [statix];
      };

      aarch64-linux.default = pkgs.arm.mkShell {
        buildInputs = with pkgs.arm; [statix];
      };
    };

    formatter = {
      x86_64-linux = pkgs.x86.alejandra;
      aarch64-linux = pkgs.arm.alejanda;
    };
  };
}
