#
#  Terminal Emulator
#

{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = "FiraCode Nerd Font";
            bold = { style = "Bold"; };
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
}
