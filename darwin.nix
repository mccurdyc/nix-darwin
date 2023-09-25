name: {
  user,
  inputs,
  nixpkgs,
  lib,
  home-manager,
  system,
  darwin,
}:
darwin.lib.darwinSystem {
  system = "aarch64-darwin";

  inputs = {inherit user inputs nixpkgs lib home-manager system darwin;};

  # nix-darwin level modules
  modules = [
    ./modules/nix.nix
    ./modules/environment.nix
    ./modules/zsh.nix
    ./modules/darwin.nix
    ./modules/skhd.nix
    ./modules/yabai.nix

    # The home-manager nix-darwin module
    home-manager.darwinModules.home-manager
    {
      users.users.${user} = {
        name = "${user}";
        home = "/Users/${user}";
      };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = {
          imports = [
            ./home-modules/alacritty.nix
            ./home-modules/darwin.nix
            ./home-modules/direnv.nix
            ./home-modules/git.nix
            ./home-modules/gpg.nix
            ./home-modules/zsh.nix
            ./home-modules/packages.nix
            ./home-modules/nvim/default.nix
          ];
        };

        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          currentSystem = system;
          isDarwin = true;
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
