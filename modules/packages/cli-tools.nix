{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Modern Unix replacements
    bat           # Better cat with syntax highlighting
    eza           # Better ls with icons and git integration
    fd            # Better find
    ripgrep       # Better grep (rg)

    # Search and fuzzy finding
    fzf           # Fuzzy finder for command line

    # Directory navigation
    zoxide        # Smart cd replacement (z command)

    # File management
    tree          # Display directory tree
    unzip         # Extract zip files
    zip           # Create zip archives
    file          # Determine file type

    # System utilities
    which         # Locate commands
    lsof          # List open files
    btop          # System monitor (better top)
    lm_sensors    # Hardware sensors (temperature, etc.)
    pciutils      # PCI utilities (lspci)

    # Shell enhancement
    starship      # Cross-shell prompt
    atuin         # Magical shell history in SQLite

    # Clipboard (Wayland)
    wl-clipboard  # wl-copy, wl-paste for Wayland

    # Security
    gnupg         # GPG encryption
    pass          # Password manager (uses GPG)

    # Terminal emulators
    ghostty       # Fast GPU-accelerated terminal
    kitty         # GPU-accelerated terminal with images

    # System info
    fastfetch     # Fast system info (like neofetch but faster)
    neofetch      # System info with ASCII art

    # Network utilities
    curl          # Transfer data with URLs
    wget          # Download files from web
  ];
}
