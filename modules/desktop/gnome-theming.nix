{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Theme & Icons
    nordic
    papirus-icon-theme
    bibata-cursors

    # GNOME Extensions
    gnome-tweaks
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnomeExtensions.vitals
    gnomeExtensions.net-speed-simplified
    gnomeExtensions.openmeteoweather
    gnomeExtensions.spotify-tray
    gnomeExtensions.caffeine  # Prevent sleep/screen lock

    # Tools
    dconf-editor
    snapshot  # Modern GNOME webcam app (replacement for Cheese)
    espanso-wayland  # Text expander
    obsidian  # Note-taking app

    # Apps with tray icons
    slack
    discord
  ];

  # Basic GNOME theming only - extensions configured manually
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.interface]
    gtk-theme='Nordic'
    icon-theme='Papirus-Dark'
    cursor-theme='Bibata-Modern-Classic'
    font-name='Inter 11'
    document-font-name='Inter 11'
    monospace-font-name='JetBrainsMono Nerd Font 11'
    color-scheme='prefer-dark'

    [org.gnome.desktop.wm.preferences]
    button-layout='appmenu:minimize,maximize,close'
    titlebar-font='Inter Bold 11'
  '';

  # Font configuration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
    noto-fonts
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Inter" "Roboto" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
