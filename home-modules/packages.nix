{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.packages;
in {
  options.modules.packages = {
    enable = mkEnableOption "packages";
    additionalPackages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    basePackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        _1password
        alejandra
        bat
        cachix
        crane
        cue
        cuelsp
        cuetools
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
        k6
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
        poetry
        python310Packages.grip
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
        viceroy
        watch
        wdiff
        yamllint
      ];
    };
  };
  config =
    mkIf cfg.enable
    {
      home.packages = with pkgs;
        cfg.basePackages ++ cfg.additionalPackages;
    };
}
