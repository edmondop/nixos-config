{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    git-delta
    lazygit
    gh
    lazydocker
    docker-compose
    taskwarrior
    jq
    yq-go
    imagemagick
    protobuf
    sqlite
    tmux
    lf
  ];
}
