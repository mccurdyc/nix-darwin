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
      ../modules/alacritty/default.nix
      ../modules/skhd/default.nix
      ../modules/yabai/default.nix
      ../modules/zsh/default.nix

      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
