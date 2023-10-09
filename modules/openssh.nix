{...}: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = mkDefault false;
      PermitRootLogin = "prohibit-password";
    };
  };
}
