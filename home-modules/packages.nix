{ custom-packages
, config
, lib
, pkgs
, pkgs-unstable
, inputs
, ...
}: {
  home.packages = with pkgs;
    [
      _1password
      alejandra
      bat
      cachix
      crane
      dig
      docker
      docker-compose
      fastly
      fd
      fzf
      gcc
      gh
      git-crypt
      git-workspace
      gitui
      gnumake
      go
      gofumpt
      google-cloud-sdk
      gopls
      gron
      hadolint
      htop
      jq
      lsof
      lua53Packages.luacheck
      luaformatter
      mosh
      nix-tree
      nixpkgs-fmt
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.fixjson
      nodePackages.jsonlint
      nodePackages.lua-fmt
      nodePackages.markdownlint-cli
      nodePackages.yaml-language-server
      nodejs
      openssl
      pinentry-curses
      skhd
      poetry
      python310Packages.grip
      # python310Packages.pip - use "python -m ensurepip --default-pip"
      python3Full
      qrencode
      ripgrep
      rnix-lsp
      rustup
      shfmt
      statix
      stern
      subnetcalc
      terraform
      tfswitch
      tmux
      tree
      trivy
      unzip
      vale
      watch
      wdiff
      yamllint
    ]
    ++ (with pkgs-unstable; [
      obsidian
      spotify
    ]);
}
