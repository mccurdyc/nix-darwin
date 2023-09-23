#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ mac.nix *
#       └─ ./modules
#           └─ default.nix
#

{ config, pkgs, vars, lib, ... }:

{
  imports = ( import ./modules );

  users.users.${vars.user} = {            # MacOS User
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;                     # Default Shell
  };

  networking = {
    computerName = "cmac";             # Host Name
    hostName = "faamac";
  };

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];          # Default Shell
    variables = {                         # Environment Variables
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [         # System-Wide Packages
	    alacritty
	    git
	    gnupg
	    htop
	    mosh
	    neovim
	    nixpkgs-fmt
	    tailscale
	    wireguard-go
	    wireguard-tools
		fd
      ripgrep
	    # _1password # export NIXPKGS_ALLOW_UNFREE=1
    ];
  };

  programs = {
    zsh.enable = true;                    # Shell
  };

  services = {
    nix-daemon.enable = true;             # Auto-Upgrade Daemon
  };

  homebrew = {                            # Homebrew Package Manager
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "wireguard-tools"
    ];
    casks = [
    ];
  };

  nix = {
    package = pkgs.nix;
    gc = {                                # Garbage Collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {                              # Global macOS System Settings
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {
        QuitMenuItem = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Set Default Shell

    # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  activationScripts.applications.text = lib.mkForce ''
    echo "setting up ~/Applications..." >&2
    applications="$HOME/Applications"
    nix_apps="$applications/Nix Apps"

    # Needs to be writable by the user so that home-manager can symlink into it
    if ! test -d "$applications"; then
        mkdir -p "$applications"
        chown ${vars.user}: "$applications"
        chmod u+w "$applications"
    fi

    # Delete the directory to remove old links
    rm -rf "$nix_apps"
    mkdir -p "$nix_apps"
    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
            # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
            # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
            # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
            /usr/bin/osascript -e "
                set fileToAlias to POSIX file \"$src\" 
                set applicationsFolder to POSIX file \"$nix_apps\"
                tell application \"Finder\"
                    make alias file to fileToAlias at applicationsFolder
                    # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                    set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                end tell
            " 1>/dev/null
        done
  '';
    stateVersion = 4;
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "23.05";
    };

    programs = {
      # zsh = TODO;
      alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = "FiraCode Nerd Font";
            bold = { style = "Bold"; };
            size = 18;
          };
        };
    };
  };
  };
}
