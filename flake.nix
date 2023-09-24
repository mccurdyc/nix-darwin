# Inspiration - https://github.com/MatthiasBenaets/nixos-config/blob/e88b7b0527a290542edeb2e08ee3e77571dce273/flake.nix#L71
{
  description = "darwin system";

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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      vars = {
        # Variables Used In Flake
        user = "mccurdyc";
        terminal = "alacritty";
        editor = "nvim";
      };
    in
    {

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

      # nixosConfigurations = (                                               # NixOS Configurations
      # import ./hosts {
      # inherit (nixpkgs) lib;
      # inherit inputs nixpkgs nixpkgs-unstable home-manager vars;   # Inherit inputs
      # }
      # );

      darwinConfigurations = (
        # Darwin Configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager darwin vars;
        }
      );

      # homeConfigurations = (                                                # Nix Configurations
      # import ./nix {
      # inherit (nixpkgs) lib;
      # inherit inputs nixpkgs nixpkgs-unstable home-manager vars;
      # }
      # );
    };
}
