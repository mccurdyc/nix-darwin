# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  inputs,
}: name: {
  system,
  user,
  darwin ? false,
}: let
  # DONE
  machineConfig = ../machines/${name}.nix;
  # DONE
  userOSConfig =
    ../users/${user}/${
      if darwin
      then "darwin"
      else "nixos"
    }.nix;
  # DONE
  userHMConfig = ../users/${user}/home-manager.nix;

  # NixOS vs nix-darwin functions
  systemFunc =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;
  home-manager =
    if darwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules = [
      machineConfig
      userOSConfig

      home-manager.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import userHMConfig {
          inherit inputs;
        };
      }

      # https://nix-community.github.io/home-manager/options.html
      {
        config._module.args = {
          currentSystem = system;
          currentSystemName = name;
          currentSystemUser = user;
          inherit inputs;
        };
      }
    ] ++ [
      ../modules/environment/default.nix
      ../modules/environment/variables.nix
      ../modules/fonts.nix
      ../modules/misc.nix
      ../modules/networking.nix
      ../modules/nix.nix
      ../modules/nixpkgs.nix
      ../modules/openssh.nix
      ../modules/zsh.nix

    ] ++ (if darwin
      then 
      	[
      	../modules/yabai.nix
      	../modules/skhd.nix
	]
	else 
	[]);
  }
