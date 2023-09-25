# https://github.com/cor/nixos-config/blob/3156d0ca560a8561187b0f4ab3cb25bbbb4ddc9f/flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # Stable Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      # User Environment Manager
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      # MacOS Package Management
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , flake-utils
    , darwin
    , ...
    }:
    let
      mkNixos = import ./nixos.nix;
      mkDarwin = import ./darwin.nix;

      user = "mccurdyc";
    in
    rec {
      nixosConfigurations =
        let
          system = "x86_64-linux";
        in
        {
          fgnix = mkNixos "fgnix" {
            inherit user inputs nixpkgs home-manager system;
          };

          nuc = mkNixos "nuc" {
            inherit user inputs nixpkgs home-manager system;
          };
        };

      darwinConfigurations =
        let
          system = "aarch64-darwin";
        in
        {
          faamac = mkDarwin "faamac" {
            inherit (nixpkgs) lib;
            inherit user inputs nixpkgs home-manager system darwin;
          };
        };
    }
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.alejandra;

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ nil sumneko-lua-language-server cmake-language-server ];
          };
        };
      }
    ));
}
