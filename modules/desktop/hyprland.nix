{ config, pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal for screen sharing, file picker, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    # Bar & launcher
    waybar
    rofi-wayland

    # Wallpaper
    hyprpaper

    # Notifications
    mako
    libnotify

    # Screen lock & idle
    hyprlock
    hypridle

    # Screenshots
    grim
    slurp
    satty  # annotation tool

    # Clipboard
    wl-clipboard
    cliphist

    # Hardware control
    brightnessctl
    playerctl

    # Authentication agent (polkit)
    polkit_gnome

    # GTK theming on Wayland
    nwg-look
    gsettings-desktop-schemas

    # Network / Bluetooth tray
    networkmanagerapplet
    blueman
  ];

  # Polkit authentication agent auto-start
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Enable Bluetooth (useful for blueman applet)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
}
