{ config, pkgs, ... }:

{
  # Enable Docker
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    awscli2
    kubectl
    kubernetes-helm
    k9s
    terraform
    opentofu
    packer
    dbt
    w3m
    docker-compose
  ];
}
