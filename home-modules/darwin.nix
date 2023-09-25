{ config
, pkgs
, lib
, inputs
, ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  home.stateVersion = "22.05";

  home.packages =
    (with pkgs; [
      fzf
      git
      git-lfs
      exa
      bat
      jq
      tree
      _1password
      ripgrep
      mosh
      openssl
      tmux
    ])
    ++ (with pkgs-unstable; [ obsidian ]);

  # Need to run `vale sync` to install styles.
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    # gem env gemdir
    "$HOME/.local/share/gem/ruby/3.1.0/bin"
    # python -m ensurepip --default-pip
    "$HOME/.local/bin"
  ];

  # Hide "last login" message on new terminal.
  home.file.".hushlogin".text = "";

  # programs.ssh doesn't work well for darwin.
  home.file.".ssh/config".text = ''
    Host *
      IdentityFile ~/.ssh/fastly_rsa
  '';

  xdg.configFile."yamllint/config".text = ''
    rules:
      document-start:
        present: true
  '';
}
