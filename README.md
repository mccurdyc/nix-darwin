# Mac Setup

## Inspiration

- [MatthiasBenaets/nixos-config](https://github.com/MatthiasBenaets/nixos-config/tree/76eea152f56e1a8f4c908b65028e8aa2f7bafaaa)
    - [For Mac](https://github.com/MatthiasBenaets/nixos-config/blob/76eea152f56e1a8f4c908b65028e8aa2f7bafaaa/README.org#nix-darwin-installation-guide)
- [core/nixos-config](https://github.com/cor/nixos-config/blob/3156d0ca560a8561187b0f4ab3cb25bbbb4ddc9f/flake.nix#L62)
    - Shared modules

## Steps

1. Manual App installs for apps that just don't seem to work when installed via nix-darwin

    - GoodNotes 5
    - Firefox
    - 1Password (GUI)
    - Zoom

1. Install Nix

    ```bash
    sh <(curl -L https://nixos.org/nix/install)
    ```

    ```bash
    mkdir ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
    ```

1. Clone nixos-config repo

    ```bash
    nix-env -iA nixpkgs.git
    git clone https://github.com/mccurdyc/nixos-config ~/nixos-config
    cd ~/nixos-config
    ln -s $HOME/nixos-config $HOME/.config/nixpkgs
    ```

1. Rebuild

    ```bash
    sudo NIXPKGS_ALLOW_UNFREE=1 \
    HOME=/var/root NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt \
    nix build --extra-experimental-features 'nix-command flakes' --impure .#darwinConfigurations.faamac.system
    ```

    Activate

    ```bash
    ./result/sw/bin/darwin-rebuild switch --flake .#faamac
    ```

1. Start tailscale daemon

    ```bash
    sudo tailscaled install-system-daemon
    tailscale login
    ```

## Common Commands

### Rebuilding System

```zsh
NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --impure --flake '.#faamac'
```

### Formatting

```bash
nix fmt
```

## References

- nix-darwin config options - https://daiderd.com/nix-darwin/manual/index.html#sec-options
- https://github.com/LnL7/nix-darwin/wiki/Changing-the-configuration.nix-location
Confirmed nix-darwin is what Mitchell Hashimoto uses - https://github.com/mitchellh/nixos-config

## Open Questions

- GUI Apps - https://github.com/LnL7/nix-darwin/issues/139#issuecomment-666771621
