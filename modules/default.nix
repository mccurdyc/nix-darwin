{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./alacritty
    ./skhd
    ./yabai
    ./zsh
  ];
}
