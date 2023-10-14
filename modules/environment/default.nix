{
  pkgs,
  lib,
  ...
}: {
  environment = {
    shells = with pkgs; [zsh]; # Default Shell

    systemPackages = with pkgs; [
      _1password # export NIXPKGS_ALLOW_UNFREE=1
      alacritty
      curl
      git
      gnumake
      coreutils
      cmake
      gnupg
      mosh
      neovim
      tailscale
      wget
      wireguard-go
      wireguard-tools
      zsh
      (writeShellScriptBin "docker-stop-all" ''
        docker stop $(docker ps -q)
        docker system prune -f
      '')
      (writeShellScriptBin "docker-prune-all" ''
        docker-stop-all
        docker rmi -f $(docker images -a -q)
        docker volume prune -f
      '')
    ];

    variables = import ./variables.nix;
  };
}