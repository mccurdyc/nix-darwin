{ vars
, pkgs
, ...
}: {
  users = {
    mutableUsers = false;
    users.${vars.user} = {
      isNormalUser = true;
      home = "/home/${vars.user}";
      extraGroups = [ "docker" "wheel" ];
      shell = pkgs.zsh;
      # https://github.com/NixOS/nixpkgs/blob/8a053bc2255659c5ca52706b9e12e76a8f50dbdd/nixos/modules/config/users-groups.nix#L43
      # mkpasswd -m sha-512
      hashedPassword = vars.hashedPassword;
      openssh.authorizedKeys.keys = vars.authorizedKeys;
    };
  };
}
