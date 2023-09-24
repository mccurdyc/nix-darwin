{ inputs
, pkgs
, config
, ...
}: {
  home.stateVersion = "23.05";
  imports = [
    ./alacritty
    ./direnv
    ./git
    ./gpg
    ./home
    ./nvim
    ./packages
    ./skhd
    ./ssh
    ./tmux
    ./yabai
    ./zsh
  ];
}
