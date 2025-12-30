{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    eza
    fd
    ripgrep
    fzf
    zoxide
    tree
    unzip
    zip
    file
    which
    lsof
    btop
    lm_sensors
    pciutils
    starship
    atuin
    wl-clipboard
    gnupg
    pass
    ghostty
    kitty
    fastfetch
    neofetch
    curl
    wget
    oh-my-zsh
    zinit
    foliate
  ];
}
