{
  description = "Edmondo's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/nixos/configuration.nix
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

