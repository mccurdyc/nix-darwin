{
  pkgs,
  lib,
  currentSystemName,
  ...
}: {
  environment = {
    shells = with pkgs; [zsh]; # Default Shell

    systemPackages = with pkgs;
      [
        _1password # export NIXPKGS_ALLOW_UNFREE=1
        alacritty
        gnupg
        mosh
        neovim
        tailscale
        wireguard-go
        wireguard-tools
        (writeShellScriptBin "docker-stop-all" ''
          docker stop $(docker ps -q)
          docker system prune -f
        '')
        (writeShellScriptBin "docker-prune-all" ''
          docker-stop-all
          docker rmi -f $(docker images -a -q)
          docker volume prune -f
        '')
      ]
      ++ lib.optionals (currentSystemName == "foobar") [
      ];

    variables = import ./environment/variables.nix;

    # required for zsh autocomplete
    pathsToLink = ["/share/zsh"];
  };
}
