{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python312
    nodejs_22
    go
    rustc
    cargo
    ruby
    lua
    luajit
    luarocks
  ];
}
