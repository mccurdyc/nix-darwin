name: {
  custom-packages,
  inputs,
  nixpkgs,
  home-manager,
  system,
  user,
}:
nixpkgs.lib.nixosSystem rec {
  inherit system;

  # NixOS level modules
  modules = [
    # inputs.union.nixosModules.hubble
    ./hardware/${name}.nix
    ./machines/${name}.nix
    ./modules/environment.nix
    ./modules/fonts.nix
    ./modules/misc.nix
    ./modules/networking.nix
    ./modules/nix.nix
    ./modules/nixpkgs.nix
    ./modules/openssh.nix
    ./modules/users.nix
    ./modules/zsh.nix

    # The home-manager NixOS module
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = {
          # Home-manager level modules
          imports = [
            ./home-modules/bat.nix
            ./home-modules/direnv.nix
            ./home-modules/git.nix
            ./home-modules/gpg.nix
            ./home-modules/nixos-misc.nix
            ./home-modules/packages.nix
            ./home-modules/tmux.nix
            ./home-modules/zsh.nix
          ];
        };
        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-kitty = import inputs.nixpkgs-kitty {
            inherit system;
            config.allowUnfree = true;
          };
          inherit custom-packages;
          currentSystemName = name;
          currentSystem = system;
          isDarwin = false;
          inherit inputs;
        };
      };
    }

    # Arguments that are exposed to every `module`.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    }
  ];
}
