{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python312
    nodejs_22
    bun
    go
    rustc
    cargo
    ruby
    lua
    luajit
    luarocks
  ];
}
