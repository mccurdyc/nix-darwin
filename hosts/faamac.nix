{pkgs-unstable, ...}: {
  config.modules.packages = {
    enable = true;
    additionalPackages = with pkgs-unstable; [
      obsidian
      spotify
      infra
    ];
  };
}
