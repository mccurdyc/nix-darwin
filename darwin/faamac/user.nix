{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: {
  config.modules = {
    alacritty.enable = true;
    skhd.enable = true;
    yabai.enable = true;
    # nvim.enable = true;
    zsh.enable = true;
    # ssh.enable = true;
    # git.enable = true;
  };
}
