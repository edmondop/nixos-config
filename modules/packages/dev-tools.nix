{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    delta
    lazygit
    gh
    turbo
    gemini-cli
    git-filter-repo
    git-lfs
    lazydocker
    docker-compose
    taskwarrior2
    jq
    yq-go
    imagemagick
    opencode
    protobuf
    sqlite
    tmux
    lf
    chezmoi
  ];
}
