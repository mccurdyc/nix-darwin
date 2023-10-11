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

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flake-utils,
    darwin,
    ...
  }: let
    mkNixos = import ./nixos.nix;
    mkDarwin = import ./darwin.nix;

    user = "mccurdyc";
    hashedPassword = "$6$d5uf.fUvF9kZ8iwH$/Bm6m3Hk82rj2V4d0pba1u6vCXIh/JLURv6Icxf1ok0heX1oK6LwSIXSeIOPriBLBnpq3amOV.pWLas0oPeCw1";
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2cxynJf1jRyVzsOjqRYVkffIV2gQwNc4Cq4xMTcsmN"
    ];
  in
    rec {
      nixosConfigurations = let
        system = "x86_64-linux";
      in {
        fgnix = mkNixos {
          vars = {
            inherit user hashedPassword authorizedKeys;
            name = "fgnix";
            hardware = "gce-x86_64-vm";
          };
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager system;
        };

        nuc = mkNixos {
          vars = {
            inherit user hashedPassword authorizedKeys;
            name = "nuc";
            hardware = "x86_64";
          };
          inherit (nixpkgs) lib;
          inherit nixpkgs home-manager system;
        };
      };

      darwinConfigurations = let
        system = "aarch64-darwin";
      in {
        faamac = mkDarwin {
          vars = {
            inherit user;
            name = "faamac";
          };

          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager system darwin;
        };
      };
    }
    // (flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        formatter = pkgs.alejandra;

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [nil sumneko-lua-language-server cmake-language-server];
          };
        };
      }
    ));
}
