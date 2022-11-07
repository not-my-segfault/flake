{
  description = "Michal's Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  } @ inputs: let
    modules = {
      home = {
        common = [./users/michal/shell.nix ./users/michal/base.nix];
        dev = [./users/michal/dev.nix];
      };
      nixos = {
        common = [
          ./common/nix.nix
          ./common/personal.nix
          ./common/yubikey.nix
          ./common/security.nix
        ];
        dev = [
          ./common/dev/distrobox.nix
          ./common/dev/podman.nix
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
            ++ modules.nixos.desktops.common;
          sway =
            [
              ./common/desktop/sway.nix
            ]
            ++ modules.nixos.desktops.common;
          gnome =
            [
              ./common/desktop/gnome.nix
            ]
            ++ modules.nixos.desktops.common;
        };
        server = [];
      };
    };

    pkgs = with nixpkgs.legacyPackages; {
      inherit x86_64-linux;
      inherit aarch64-linux;
    };

    defaultModules = x:
      nixpkgs.lib.forEach ["base.nix" "hardware.nix"] (
        mod: (./. + "/devices" + ("/" + x) + ("/" + mod))
      )
      ++ [./devices/common.nix]
      ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = modules.home.common ++ modules.home.dev;
        }
      ];
  in {
    homeConfigurations = {
      "michal" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs.x86_64-linux;
        modules = modules.home.common ++ modules.home.dev;
      };

      "michal@nixos-rpi" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs.aarch64-linux;
        modules = modules.home.common ++ modules.home.dev;
      };
    };

    nixosConfigurations = {
      "nixos-station" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          defaultModules "station"
          ++ modules.nixos.desktops.gnome
          ++ modules.nixos.common
          ++ modules.nixos.dev;
      };

      "nixos-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          defaultModules "laptop"
          ++ modules.nixos.desktops.kde
          ++ modules.nixos.common;
      };

      "nixos-rpi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules =
          defaultModules "rpi"
          ++ modules.nixos.common
          ++ modules.nixos.desktops.sway
          ++ modules.nixos.dev
          ++ [nixos-hardware.nixosModules.raspberry-pi-4];
      };
    };

    devShells = {
      x86_64-linux.default = pkgs.x86_64-linux.mkShell {buildInputs = with pkgs.x86_64-linux; [statix];};
      aarch64-linux.default = pkgs.aarch64-linux.mkShell {buildInputs = with pkgs.aarch64-linux; [statix];};
    };

    formatter = {
      x86_64-linux = pkgs.x86_64-linux.alejandra;
      aarch64-linux = pkgs.aarch64-linux.alejanda;
    };
  };
}
