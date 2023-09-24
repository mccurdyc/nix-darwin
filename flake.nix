# Inspiration - https://github.com/MatthiasBenaets/nixos-config/blob/e88b7b0527a290542edeb2e08ee3e77571dce273/flake.nix#L71
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # Stable Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages

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
    darwin,
    ...
  }: let
    vars = {
      # Variables Used In Flake
      user = "mccurdyc";
      # https://github.com/NixOS/nixpkgs/blob/8a053bc2255659c5ca52706b9e12e76a8f50dbdd/nixos/modules/config/users-groups.nix#L43
      # mkpasswd -m sha-512
      hashedPassword = "$6$d5uf.fUvF9kZ8iwH$/Bm6m3Hk82rj2V4d0pba1u6vCXIh/JLURv6Icxf1ok0heX1oK6LwSIXSeIOPriBLBnpq3amOV.pWLas0oPeCw1";
      terminal = "alacritty";
      editor = "nvim";
    };
  in {
    formatter = {
      "aarch64-darwin" = nixpkgs.legacyPackages."aarch64-darwin".alejandra;
      "x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    };

    nixosConfigurations = (
      import ./nixos {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager vars;
      }
    );

    darwinConfigurations = (
      import ./darwin {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager darwin vars;
      }
    );
  };
}
