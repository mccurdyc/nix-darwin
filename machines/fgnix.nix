{pkgs, ...}: {
imports = [
./hardware/vm-gce-x86_64.nix
];

  config.modules.packages = {
    enable = true;
    additionalPackages = with pkgs; [
      awscli2
      infra
      kubectl
      kubernetes-helm
      kubie
      ssm-session-manager-plugin
      ruby_3_1
      terraform-docs
      terraform-ls
      tflint
      wireguard-tools
    ];
  };
}
