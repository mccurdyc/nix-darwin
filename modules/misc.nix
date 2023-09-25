{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  currentSystemName,
  ...
}: {
  security = {
    sudo.wheelNeedsPassword = false;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  virtualisation.docker.enable = true;
}
