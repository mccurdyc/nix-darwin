{
  lib,
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  vars,
  ...
}: let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  nuc = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system unstable vars;
      host.hostName = "nuc";
    };

    modules = [
      "./configuration.nix"
      "./nuc/hardware-configuration.nix"
      "./nuc/user.nix"

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  fgnix = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system unstable vars;
      host.hostName = "fgnix";
    };

    modules = [
      "./configuration.nix"
      "./fgnix/hardware-configuration.nix"
      "./fgnix/user.nix"

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
