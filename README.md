# Mac Setup

1. Manual App Store installs for apps that just don't seem to work when installed via nix-darwin

- GoodNotes 5

1. Manual App installs for apps not in the App Store that also don't seem to work via nix-darwin

- Firefox
- Obsidian
- 1Password

1. Install Nix

- https://github.com/DeterminateSystems/nix-installer

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

1. Install nix-darwin

- https://github.com/LnL7/nix-darwin

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

```bash
sudo mv /etc/nix/nix.{conf,conf.bak}
nix-channel --add http://nixos.org/channels/nixpkgs-23.05 nixpkgs
nix-channel --update
./result/bin/darwin-installer 
source /etc/static/zshrc
mkdir -p ~/.config/darwin
```

Copied default configs from nix-darwin README

```bash
cat <<EOF > ~/.config/darwin/configuration.nix
{ config, pkgs, lib, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.neovim
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
EOF
```

The default system hostname is `MacBook-Pro` we will change that.
```bash
cat <<EOF > ~/.config/darwin/flake.nix
{
  description = "darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs }: {
    darwinConfigurations."MacBook-Pro" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./configuration.nix ];
    };
  };
}
EOF
```

re-build system
```bash
nix build --experimental-features 'nix-command' --extra-experimental-features 'flakes' ~/.config/darwin\#darwinConfigurations.MacBook-Pro.system
darwin-rebuild switch --flake ~/.config/darwin
```

Change the hostname to `faamac` in `~/.config/darwin/configuration.nix`.

```nix
networking.hostName = "faamac";
```

Change the hostname to `faamac` in `~/.config/darwin/flake.nix`

```nix
```

re-build system
```bash
nix build --experimental-features 'nix-command' --extra-experimental-features 'flakes' ~/.config/darwin\#darwinConfigurations.faamac.system
darwin-rebuild switch --flake ~/.config/darwin
```

Start tailscale daemon
```bash
sudo tailscaled install-system-daemon
tailscale login
```


# References
- nix-darwin config options - https://daiderd.com/nix-darwin/manual/index.html#sec-options
- https://github.com/LnL7/nix-darwin/wiki/Changing-the-configuration.nix-location
Confirmed nix-darwin is what Mitchell Hashimoto uses - https://github.com/mitchellh/nixos-config


# Open Questions

- GUI Apps - https://github.com/LnL7/nix-darwin/issues/139#issuecomment-666771621
