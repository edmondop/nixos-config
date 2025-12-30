# NixOS Configuration Modules

This directory contains modular NixOS configuration files organized by purpose.

## Structure

### `packages/`
Package installation modules (imported into `environment.systemPackages`):
- `cli-tools.nix` - Core CLI utilities (bat, eza, fd, ripgrep, fzf, etc.)
- `dev-tools.nix` - Development tools (git, lazygit, neovim, docker, etc.)
- `languages.nix` - Base language runtimes (python, node, go, rust, ruby, lua)
- `version-managers.nix` - Version managers (pyenv, fnm, mise, rustup, rbenv)
- `infrastructure.nix` - Cloud & IaC tools (aws-cli, kubectl, terraform, etc.)

### `desktop/`
Desktop environment configurations:
- `gnome.nix` - GNOME desktop (current default)
- `sway.nix` - Sway tiling window manager (to be added)

### `system/`
System-level configurations:
- `shell.nix` - Shell configuration (ZSH, environment variables)

## Usage

Modules are imported in `hosts/nixos/configuration.nix`:

```nix
imports = [
  ./hardware-configuration.nix
  ../../modules/packages/cli-tools.nix
  ../../modules/desktop/gnome.nix
  # ... other modules
];
```

## Note

Dotfiles (~/.zshrc, ~/.config/nvim/, etc.) are managed by **chezmoi**, not by these modules.
These modules only handle package installation and system-level configuration.
