{ nixpkgs-unstable }: {
  additionalPackages = with nixpkgs-unstable; [
    obsidian
    spotify
    infra
  ];
}
