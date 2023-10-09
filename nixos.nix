{
  inputs,
  nixpkgs,
  home-manager,
  system,
  vars,
}:
nixpkgs.lib.nixosSystem rec {
  inherit system;

  inputs = {inherit inputs nixpkgs home-manager system vars;};

  # NixOS level modules
  modules = [
    "./hardware/${vars.hardware}.nix"
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
        users.${vars.user} = {
          # Home-manager level modules
          imports = [
            ./home-modules/direnv.nix
            ./home-modules/git.nix
            ./home-modules/gpg.nix
            ./home-modules/home.nix
            ./home-modules/packages.nix
            ./home-modules/ssh.nix
            ./home-modules/tmux.nix
            ./home-modules/zsh.nix

            ./hosts/${vars.name}.nix # NOTE - this works even though the linter complains.
          ];
        };

        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          currentSystemName = vars.name;
          currentSystem = system;
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

          isDarwin = false;
          inherit inputs;
        };
      };
    }

    # Arguments that are exposed to every `module`.
    {
      config._module.args = {
        currentSystemName = vars.name;
        currentSystem = system;
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    }
  ];
}
