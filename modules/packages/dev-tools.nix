{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    delta
    lazygit
    gh
    lazydocker
    docker-compose
    taskwarrior2
    jq
    yq-go
    imagemagick
    protobuf
    sqlite
    tmux
    lf
  ];
}
