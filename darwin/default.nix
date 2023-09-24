{
  lib,
  inputs,
  nixpkgs,
  darwin,
  home-manager,
  vars,
  ...
}: let
  system = "aarch64-darwin";
in {
  faamac = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {inherit inputs vars;};
    modules = [
      ./configuration.nix
      ./faamac/user.nix

      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
