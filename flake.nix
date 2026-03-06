{
  description = "Edmondo's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    jj-starship.url = "github:dmmulroy/jj-starship";
  };

  outputs = { self, nixpkgs, jj-starship }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    nixosConfigurations.framework-13-nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/nixos/configuration.nix
        {
          nixpkgs.overlays = [ jj-starship.overlays.default ];
        }
      ];
    };

    packages.${system}.pyenv-shell = (pkgs.buildFHSEnv {
      name = "pyenv-shell";
      targetPkgs = pkgs: (with pkgs; [
        # Core build tools
        gcc
        gnumake
        binutils
        coreutils
        git

        # Python build dependencies
        zlib
        readline
        openssl
        bzip2
        ncurses
        sqlite
        xz
        libffi
        expat
        gdbm
        tk
      ]);
      runScript = "zsh";
    });
  };
}
