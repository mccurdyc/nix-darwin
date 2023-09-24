{ config, lib, pkgs, inputs, vars, ... }:

{
  config.modules = {
    skhd.enable = true;
    yabai.enable = true;
  };
}
