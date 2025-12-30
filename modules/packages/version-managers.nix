{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pyenv
    fnm
    mise
    rustup
    rbenv
  ];
}
