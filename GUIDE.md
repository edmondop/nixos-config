# The NixOS Desktop Field Guide

> A no-BS explanation of the stuff you've been clicking on without knowing what it does.

---

## Part 1: The Graphics Stack — What's Actually Drawing Your Screen

### What is a compositor?

Before GNOME, Hyprland, or anything else makes sense, you need to know this.

Your GPU produces pixels. But something has to decide *which* pixels go where — taking every open window, every animation, every shadow, and combining them into the final image you see. That thing is the **compositor**.

Think of it like a video editor doing a live render:
- Each window is a "clip" (a buffer of pixels)
- The compositor layers them, applies effects (blur, transparency, shadows), and outputs the final frame to your monitor

On Linux, compositors talk to apps via a **display protocol**:
- **X11** — the old one (30+ years old). Apps draw directly to a shared screen buffer. Messy, insecure, but compatible with everything.
- **Wayland** — the modern one. Each app gets its own isolated buffer. The compositor controls everything. More secure, smoother, but some older apps don't support it yet.

Your system runs **Wayland**.

### So what is GNOME then?

GNOME is a **desktop environment** — a bundle that includes:
- A compositor (called **Mutter**)
- A panel/taskbar (the bar at the top)
- A file manager, settings app, and other apps
- A shell (the Activities overview, notifications, etc.)

GNOME = Mutter (compositor) + GNOME Shell (the UI on top) + apps.

### And Hyprland?

Hyprland is **just a compositor** — but one that also handles window management with a tiling layout. It has no panel, no file manager, no settings app. You build everything yourself from separate pieces (waybar for the panel, rofi for launcher, etc.).

You have both installed. GDM (the login screen) lets you pick which one to start. Currently you're using GNOME.

---

## Part 2: GNOME

### The panel zones

Your top bar has three zones:

```
[Activities] [Vitals stats]     [Clock]     [Wifi/Battery/Volume ▾]
      LEFT                     CENTER              RIGHT
```

- **Left**: Activities button, app menu, any left-anchored extensions (Vitals)
- **Center**: Clock. Click it to see notifications and calendar.
- **Right**: System indicators. **Click here to get the power/restart menu.**

That's where restart lives. Always. Click the right side of the top bar → a dropdown appears → hold Alt to turn the "Power Off" button into "Restart", or click the power icon.

### The Activities overview

When you click **Activities** (top-left button) or press **Super**, you get:

1. All open windows spread out (Exposé-style) — so you can click the one you want
2. A search bar at the top — type anything: app names, files, settings, calculator math
3. Scroll down (or press Super again) to get the full **app grid**

It's not minimizing your windows. It's showing them all at once so you can pick one. The windows are still running.

### Extensions

GNOME Shell can be extended with JavaScript plugins called **extensions**. They run inside the shell process and can do anything: add panel widgets, change behaviors, add buttons.

You have these enabled:
| Extension | What it does |
|-----------|-------------|
| **Vitals** | CPU/memory/network stats in the panel |
| **Just Perfection** | Lets you resize the panel, hide elements, tweak spacing |
| **Blur My Shell** | Adds blur effects to the panel and overview |
| **AppIndicator** | Shows tray icons (Slack, Discord, etc.) in the panel |
| **Caffeine** | Prevents the screen from sleeping |
| **Spotify Tray** | Spotify controls in the tray |
| **Net Speed Simplified** | Network speed in the panel |
| **OpenMeteo Weather** | Weather widget |
| **User Themes** | Lets you use custom GTK themes |

Extensions are powerful but fragile — they break on GNOME updates because they hook deep into the shell.

### Hot corners

By default, moving your mouse to the **top-left corner** (not clicking — just hovering) triggers the Activities overview. This is the "hot corner." It's separate from clicking the Activities button.

You can disable it with:
```
gsettings set org.gnome.desktop.interface enable-hot-corners false
```

---

## Part 3: dconf — GNOME's Settings Brain

### What is dconf?

GNOME stores all its settings in a binary database called **dconf**. Every setting you change in GNOME Settings, every extension preference, every theme — it all ends up in dconf.

You can browse it live:
```bash
dconf-editor          # GUI browser (you have it installed)
dconf dump /          # Dump everything to terminal
dconf dump /org/gnome/shell/extensions/  # Dump extension settings
```

Settings are organized in paths like a filesystem:
```
/org/gnome/desktop/interface/gtk-theme  →  "Nordic"
/org/gnome/shell/enabled-extensions    →  ["blur-my-shell@aunetx", ...]
```

### How NixOS controls dconf

Normally you'd change these settings by clicking in GNOME Settings or dconf-editor. But on NixOS, you can declare them in your config files so they're always applied, survive reinstalls, and are version-controlled.

Two ways NixOS sets dconf values:

**1. `extraGSettingsOverrides`** (in `gnome-theming.nix`)
```nix
services.desktopManager.gnome.extraGSettingsOverrides = ''
  [org.gnome.desktop.interface]
  gtk-theme='Nordic'
'';
```
This writes defaults. Users can still override them manually.

**2. `programs.dconf.profiles`** (in `configuration.nix`)
```nix
programs.dconf.profiles.user.databases = [{
  lockAll = true;
  settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ ... ];
    };
  };
}];
```
This writes to a **system dconf profile** that loads before the user's profile.

### What `lockAll = true` does

This is the nuclear option. It **prevents the user from overriding** any setting in that database block.

Practical consequences:
- The extension list is locked — enabling an extension manually in GNOME Extensions app does nothing
- Any dconf path you add to the settings block gets locked for the whole namespace
- New extensions need to be added to this config block to be enabled
- It's useful for reproducibility but annoying when experimenting

Without `lockAll`, the NixOS settings are just defaults that you can override at runtime.

### How to inspect what's actually set

```bash
# See what the current dconf value is
gsettings get org.gnome.shell enabled-extensions

# See all Just Perfection settings
dconf dump /org/gnome/shell/extensions/just-perfection/

# See which profile is controlling a setting
dconf read /org/gnome/shell/enabled-extensions
```

---

## Part 4: Hyprland

### What you'd get

Hyprland is a **tiling window manager compositor**. Instead of floating windows you drag around, windows are automatically arranged to fill your screen:

```
┌────────────┬────────────┐      ┌────────────────────┐
│            │            │      │                    │
│  Terminal  │  Browser   │  or  │      Browser       │
│            │            │      │                    │
└────────────┴────────────┘      └────────────────────┘
   Two windows, side by side         One window, fullscreen
```

When you open a third window it splits again. Everything is keyboard-driven.

### Key concepts

**Workspaces** — like virtual desktops. You have 10. Each workspace is a separate tiling layout. Move windows between them, switch instantly.

**Master/Dwindle layout** — Hyprland's default splits the screen when new windows open:
- First window = full screen
- Second window = screen splits 50/50
- Third window = one side splits again, etc.

**Floating windows** — you can make specific windows float (like a file picker or system preferences) so they behave like normal windows.

### Your current setup

You have Hyprland installed but no config file yet (`~/.config/hypr/hyprland.conf` doesn't exist). If you log into a Hyprland session via GDM, you'd get a completely blank screen with no panel, no launcher — nothing. You'd need to build the config first.

Your `hyprland.nix` installs the tools (waybar, rofi, hyprpaper, etc.) but doesn't generate the config file that tells Hyprland how to use them.

### The typical Hyprland config

A minimal config would define:
- Your monitor layout
- Key bindings (Super+Enter = open terminal, Super+Q = close window, etc.)
- Which apps autostart (waybar, hyprpaper, etc.)
- Window rules (make Discord float, make this app always go to workspace 3, etc.)

### When to use Hyprland vs GNOME

| | GNOME | Hyprland |
|--|-------|----------|
| Setup time | Works out of the box | Hours of config |
| Mouse-friendly | Yes | Not really |
| Keyboard-centric | Partially | Fully |
| Battery efficiency | Good | Slightly better |
| App compatibility | Excellent | Good (some issues) |
| Looks | Polished by default | Stunning if configured |
| Learning curve | Low | High |

For most workflows GNOME is fine. Hyprland pays off if you live in the terminal and want every pixel controlled.

---

## Quick Reference

### GNOME keyboard shortcuts
| Shortcut | Action |
|----------|--------|
| `Super` | Activities overview |
| `Super + A` | App grid |
| `Super + H` | Hide window |
| `Super + Up` | Maximize window |
| `Super + Left/Right` | Snap window to half screen |
| `Alt + F4` | Close window |
| `Super + L` | Lock screen |
| `Super + 1-9` | Switch to workspace N |

### Where to find things
| Thing | Where |
|-------|-------|
| Restart/Shutdown | Top-right panel → power icon |
| All apps | Super → scroll down, or Super+A |
| Extension settings | Search "Extensions" in Activities |
| System settings | Search "Settings" in Activities |
| dconf browser | Run `dconf-editor` |

### Files in your NixOS config
| File | Controls |
|------|----------|
| `hosts/nixos/configuration.nix` | System-wide settings, dconf profiles, enabled extensions |
| `modules/desktop/gnome-theming.nix` | Extension packages, fonts, GTK theme |
| `modules/desktop/hyprland.nix` | Hyprland install + portal config |
