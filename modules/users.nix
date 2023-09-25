{pkgs, ...}: {
  users = {
    mutableUsers = false;
    users.mccurdyc = {
      isNormalUser = true;
      home = "/home/mccurdyc ";
      extraGroups = ["docker" "wheel"];
      shell = pkgs.zsh;
      # https://github.com/NixOS/nixpkgs/blob/8a053bc2255659c5ca52706b9e12e76a8f50dbdd/nixos/modules/config/users-groups.nix#L43
      # mkpasswd -m sha-512
      hashedPassword = "$6$d5uf.fUvF9kZ8iwH$/Bm6m3Hk82rj2V4d0pba1u6vCXIh/JLURv6Icxf1ok0heX1oK6LwSIXSeIOPriBLBnpq3amOV.pWLas0oPeCw1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2cxynJf1jRyVzsOjqRYVkffIV2gQwNc4Cq4xMTcsmN"
      ];
    };
  };
}
