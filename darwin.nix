{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  lib,
  home-manager,
  system,
  darwin,
  vars,
}:
darwin.lib.darwinSystem {
  inherit system;

  inputs = {inherit inputs nixpkgs nixpkgs-unstable lib home-manager system darwin vars;};

  # nix-darwin level modules
  modules = [
    ./modules/darwin.nix
    ./modules/environment.nix
    ./modules/nix.nix
    ./modules/skhd.nix
    ./modules/yabai.nix
    ./modules/zsh.nix

    # The home-manager nix-darwin module
    home-manager.darwinModules.home-manager
    {
      users.users.${vars.user} = {
        name = "${vars.user}";
        home = "/Users/${vars.user}";
      };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${vars.user} = {
          imports = [
            ./home-modules/alacritty.nix
            ./home-modules/direnv.nix
            ./home-modules/git.nix
            ./home-modules/gpg.nix
            ./home-modules/home.nix
            ./home-modules/nvim/default.nix
            ./home-modules/packages.nix
            ./home-modules/tmux.nix
            ./home-modules/ssh.nix
            ./home-modules/zsh.nix
            ./hosts/${vars.name}.nix
          ];
        };

        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          currentSystemName = vars.name;
          currentSystem = system;
          isDarwin = true;
        };
      };
    }

    # Arguments that are exposed to every `module`.
    {
      config._module.args = {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        currentSystemName = vars.name;
        currentSystem = system;
        isDarwin = true;
        inherit vars;
      };
    }
  ];
}
