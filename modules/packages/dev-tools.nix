{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    jujutsu
    jj-starship
    delta
    lazygit
    gh
    turbo
    gemini-cli
    git-filter-repo
    git-lfs
    lazydocker
    docker-compose
    taskwarrior3
    jq
    yq-go
    imagemagick
    opencode
    protobuf
    sqlite
    sqlitebrowser
    tmux
    lf
    chezmoi
  ];
}
