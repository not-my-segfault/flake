{

  description = "Michal's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, ... }@inputs:

    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      devShell = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            nix-linter
						statix
            nixfmt
          ];
        }
      );

      nixosConfigurations."nixos-station" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./station/hardware.nix
          ./station/base.nix
          ./station/dev.nix
          ./station/gaming.nix

          ./common/kde.nix
          ./common/media.nix
          ./common/nix.nix
          ./common/personal.nix
          ./common/yubikey.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.michal = import ./common/michal.nix;
          }
        ];
      };

      nixosConfigurations."nixos-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./laptop/base.nix
          ./laptop/hardware.nix

          ./common/kde.nix
          ./common/media.nix
          ./common/nix.nix
          ./common/personal.nix
          ./common/yubikey.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.michal = import ./common/michal.nix;
          }
        ];
      };

      nixosConfigurations."nixos-rpi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ( _ : { nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ]; })

          ./rpi/hardware.nix
          ./rpi/base.nix
          ./rpi/media.nix
          ./rpi/personal.nix
          ./rpi/sway.nix

          ./common/nix.nix
          ./common/yubikey.nix


          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.michal = import ./common/michal.nix;
          }
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
}
