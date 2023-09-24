{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib; let
  cfg = config.modules.alacritty;
in {
  options.modules.alacritty = {enable = mkEnableOption "alacritty";};
  config = mkIf cfg.enable {
    home-manager.users.${vars.user} = {
      programs = {
        alacritty = {
          enable = true;
          settings = {
            font = {
              normal.family = "FiraCode Nerd Font";
              bold = {style = "Bold";};
              size = 22;
            };

            window.dimensions = {
              lines = 30;
              columns = 100;
            };

            # remove titlebar
            window.decorations = "None";
          };
        };
      };
    };
  };
}
