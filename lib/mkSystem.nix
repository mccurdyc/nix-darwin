# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  nixpkgs-unstable,
  inputs,
  lib,
  }:
name: {
  system,
  user,
  profile,
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
  profileHMConfig = ../machines/profiles/${profile}/home-manager.nix;

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
        home-manager = {
	useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = import userHMConfig {
          inherit inputs nixpkgs-unstable;
        };
	# passed to every `home-module`.
        extraSpecialArgs = {
          inherit inputs darwin;
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
	};
      }

      # passed to every module
      {
        config._module.args = {
          inherit inputs;
          currentSystem = system;
          currentSystemName = name;
          currentSystemUser = user;
	  pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        };
      }
    ] ++ [
      ../modules/environment.nix
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
