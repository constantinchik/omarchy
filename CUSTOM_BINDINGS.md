# Custom Keybindings Configuration

This document defines a clean, vim-inspired keybinding scheme for omarchy with focus-or-launch app bindings.

## Philosophy

1. **Vim-style navigation**: hjkl for all directional movement
2. **SUPER+hjkl**: Focus windows in direction
3. **CTRL+ALT+hjkl**: Move/snap windows in direction
4. **App launchers**: Focus if already open, launch if not
5. **Non-conflicting**: Avoid conflicts with omarchy defaults where possible

---

## 1. Window Navigation & Management

### Focus Movement (SUPER+hjkl)
```conf
# Replace omarchy's SUPER+arrows with vim keys
bind = SUPER, h, movefocus, l
bind = SUPER, j, movefocus, d
bind = SUPER, k, movefocus, u
bind = SUPER, l, movefocus, r
```

### Window Snapping/Movement (CTRL+ALT+hjkl)
```conf
# Move windows to edges (snapping)
bind = CTRL ALT, h, movewindow, l
bind = CTRL ALT, j, movewindow, d
bind = CTRL ALT, k, movewindow, u
bind = CTRL ALT, l, movewindow, r
```

### Window Swapping (SUPER+SHIFT+hjkl)
```conf
# Swap window positions (keep omarchy's function, change to vim keys)
bind = SUPER SHIFT, h, swapwindow, l
bind = SUPER SHIFT, j, swapwindow, d
bind = SUPER SHIFT, k, swapwindow, u
bind = SUPER SHIFT, l, swapwindow, r
```

### Workspace Navigation
```conf
# Keep both arrow and number approaches
bind = SUPER, left, workspace, r-1
bind = SUPER, right, workspace, r+1
bind = SUPER CTRL, down, workspace, empty

# Workspace numbers (already in omarchy)
# SUPER+[1-9,0] for workspace switching
```

### Move Window to Workspace
```conf
# Relative movement with vim-style
bind = SUPER ALT, h, movetoworkspace, r-1
bind = SUPER ALT, l, movetoworkspace, r+1

# Keep omarchy's SUPER+SHIFT+[1-9,0] for specific workspaces
```

---

## 2. Focus-or-Launch App Bindings

### Concept
Each app binding should:
1. Check if a window of that class exists
2. If exists → focus it
3. If not → launch it

### Implementation Script

Create `/home/cost/.local/share/omarchy/bin/omarchy-focus-or-launch`:

```bash
#!/bin/bash
# Focus window if exists, otherwise launch application
# Usage: omarchy-focus-or-launch <window_class> <command>

WINDOW_CLASS="$1"
shift
LAUNCH_CMD="$@"

# Check if window exists
if hyprctl clients -j | jq -e ".[] | select(.class == \"$WINDOW_CLASS\")" > /dev/null 2>&1; then
    # Window exists, focus it
    hyprctl dispatch focuswindow "class:^$WINDOW_CLASS$"
else
    # Window doesn't exist, launch it
    eval "$LAUNCH_CMD" &
fi
```

### App Bindings

```conf
# Terminal (Kitty/Ghostty)
bind = SUPER, RETURN, exec, omarchy-focus-or-launch "kitty" "kitty"
bind = SUPER, T, exec, omarchy-focus-or-launch "com.mitchellh.ghostty" "ghostty"

# Browser (Chromium)
bind = SUPER, B, exec, omarchy-focus-or-launch "chromium" "chromium"

# File Manager (Dolphin)
bind = SUPER, E, exec, omarchy-focus-or-launch "org.kde.dolphin" "dolphin"

# Code Editor (VSCode)
bind = SUPER, C, exec, omarchy-focus-or-launch "Code" "code"

# System Monitor (btop via omarchy's terminal wrapper)
bind = SUPER CTRL, M, exec, omarchy-focus-or-launch "org.omarchy.btop" "ghostty --class=org.omarchy.btop -e btop"
```

**Note:** These replace conflicting omarchy defaults:
- `SUPER+K` (was show keybindings) → Moved to `SUPER+?`
- `SUPER+T` (was toggle floating in omarchy) → Override for terminal

---

## 3. System Controls

### Help System
```conf
# Show keybindings (moved from SUPER+K to free up for vim navigation)
bind = SUPER, SLASH, exec, omarchy-menu-keybindings  # SUPER+?
```

### Lock & Power
```conf
# Lock screen
bind = SUPER, L, exec, swaylock

# Keep omarchy's system menu
# SUPER+ESCAPE for system menu (already in omarchy)
```

### Monitor Management
```conf
# Monitor configuration switcher
bind = SUPER, M, exec, omarchy-cmd-monitor-switch
```

### Keyboard Layout
```conf
# Cycle keyboard layouts (us,ua)
bind = CTRL, SPACE, exec, omarchy-cmd-keyboard-layout-switch
```

### Waybar Toggle
```conf
# Keep omarchy's binding
# SUPER+SHIFT+SPACE toggles waybar
```

### Performance Mode
```conf
# Toggle gamemode (disable effects for performance)
bind = SUPER CTRL, G, exec, omarchy-cmd-gamemode
```

### Lid Switch (Laptops)
```conf
# Auto-lock and suspend on lid close
bindl = , switch:on:Lid Switch, exec, swaylock && systemctl suspend
```

---

## 4. Complete Bindings File

Create `~/.config/hypr/bindings.conf`:

```conf
# ============================================================================
# Custom Keybindings for Omarchy
# ============================================================================

# ----------------------------------------------------------------------------
# Window Focus (SUPER+hjkl)
# ----------------------------------------------------------------------------
bind = SUPER, h, movefocus, l
bind = SUPER, j, movefocus, d
bind = SUPER, k, movefocus, u
bind = SUPER, l, movefocus, r

# ----------------------------------------------------------------------------
# Window Movement/Snapping (CTRL+ALT+hjkl)
# ----------------------------------------------------------------------------
bind = CTRL ALT, h, movewindow, l
bind = CTRL ALT, j, movewindow, d
bind = CTRL ALT, k, movewindow, u
bind = CTRL ALT, l, movewindow, r

# ----------------------------------------------------------------------------
# Window Swapping (SUPER+SHIFT+hjkl)
# ----------------------------------------------------------------------------
bind = SUPER SHIFT, h, swapwindow, l
bind = SUPER SHIFT, j, swapwindow, d
bind = SUPER SHIFT, k, swapwindow, u
bind = SUPER SHIFT, l, swapwindow, r

# ----------------------------------------------------------------------------
# Workspace Navigation (Arrows + Numbers)
# ----------------------------------------------------------------------------
bind = SUPER, left, workspace, r-1
bind = SUPER, right, workspace, r+1
bind = SUPER CTRL, down, workspace, empty

# ----------------------------------------------------------------------------
# Move Window to Workspace (SUPER+ALT+hl for relative)
# ----------------------------------------------------------------------------
bind = SUPER ALT, h, movetoworkspace, r-1
bind = SUPER ALT, l, movetoworkspace, r+1

# ----------------------------------------------------------------------------
# Application Launchers (Focus-or-Launch)
# ----------------------------------------------------------------------------
bind = SUPER, RETURN, exec, omarchy-focus-or-launch kitty kitty
bind = SUPER, T, exec, omarchy-focus-or-launch com.mitchellh.ghostty ghostty
bind = SUPER, B, exec, omarchy-focus-or-launch chromium chromium
bind = SUPER, E, exec, omarchy-focus-or-launch org.kde.dolphin dolphin
bind = SUPER, C, exec, omarchy-focus-or-launch Code code

# ----------------------------------------------------------------------------
# System Controls
# ----------------------------------------------------------------------------
# Show keybindings (moved from SUPER+K)
bind = SUPER, SLASH, exec, omarchy-menu-keybindings

# Lock and power
bind = SUPER, L, exec, swaylock

# Utilities
bind = CTRL, SPACE, exec, omarchy-cmd-keyboard-layout-switch
bind = SUPER CTRL, G, exec, omarchy-cmd-gamemode
bind = SUPER, M, exec, omarchy-cmd-monitor-switch

# Lid switch (laptops)
bindl = , switch:on:Lid Switch, exec, swaylock && systemctl suspend
```

---

## 5. Conflicts Resolution

### Omarchy Defaults Being Overridden

| Omarchy Default | Override | Reason |
|----------------|----------|--------|
| `SUPER+arrows` for focus | `SUPER+hjkl` | Vim-style navigation |
| `SUPER+SHIFT+arrows` for swap | `SUPER+SHIFT+hjkl` | Vim-style consistency |
| `SUPER+K` for show keybindings | `SUPER+?` (SLASH) | K needed for vim up |
| `SUPER+T` for toggle float | `SUPER+T` for terminal | More common use case |

### What We Keep from Omarchy

| Binding | Function | Why |
|---------|----------|-----|
| `SUPER+SPACE` | Walker launcher | Main app launcher |
| `SUPER+Q` | Close window | Standard |
| `SUPER+TAB` | Next workspace | Works alongside arrows |
| `SUPER+ESCAPE` | System menu | Power/logout |
| `SUPER+SHIFT+SPACE` | Toggle waybar | Aesthetics |
| `SUPER+CTRL+V` | Clipboard manager | Utilities |
| `SUPER+?` | Show keybindings | Help system (moved) |
| Media keys | Volume/brightness | Standard |
| `PRINT` | Screenshot | Standard |

---

## 6. Implementation Steps

### Step 1: Create Focus-or-Launch Script

```bash
cat > ~/.local/share/omarchy/bin/omarchy-focus-or-launch << 'EOF'
#!/bin/bash
# Focus window if exists, otherwise launch application
# Usage: omarchy-focus-or-launch <window_class> <command>

WINDOW_CLASS="$1"
shift
LAUNCH_CMD="$@"

# Check if window exists
if hyprctl clients -j | jq -e ".[] | select(.class == \"$WINDOW_CLASS\")" > /dev/null 2>&1; then
    # Window exists, focus it
    hyprctl dispatch focuswindow "class:^$WINDOW_CLASS$"
else
    # Window doesn't exist, launch it
    eval "$LAUNCH_CMD" &
fi
EOF

chmod +x ~/.local/share/omarchy/bin/omarchy-focus-or-launch
```

### Step 2: Create Bindings Configuration

```bash
cat > ~/.config/hypr/bindings.conf << 'EOF'
# Window Focus (SUPER+hjkl)
bind = SUPER, h, movefocus, l
bind = SUPER, j, movefocus, d
bind = SUPER, k, movefocus, u
bind = SUPER, l, movefocus, r

# Window Movement/Snapping (CTRL+ALT+hjkl)
bind = CTRL ALT, h, movewindow, l
bind = CTRL ALT, j, movewindow, d
bind = CTRL ALT, k, movewindow, u
bind = CTRL ALT, l, movewindow, r

# Window Swapping (SUPER+SHIFT+hjkl)
bind = SUPER SHIFT, h, swapwindow, l
bind = SUPER SHIFT, j, swapwindow, d
bind = SUPER SHIFT, k, swapwindow, u
bind = SUPER SHIFT, l, swapwindow, r

# Workspace Navigation
bind = SUPER, left, workspace, r-1
bind = SUPER, right, workspace, r+1
bind = SUPER CTRL, down, workspace, empty

# Move Window to Workspace
bind = SUPER ALT, h, movetoworkspace, r-1
bind = SUPER ALT, l, movetoworkspace, r+1

# Application Launchers (Focus-or-Launch)
bind = SUPER, RETURN, exec, omarchy-focus-or-launch kitty kitty
bind = SUPER, T, exec, omarchy-focus-or-launch com.mitchellh.ghostty ghostty
bind = SUPER, B, exec, omarchy-focus-or-launch chromium chromium
bind = SUPER, E, exec, omarchy-focus-or-launch org.kde.dolphin dolphin
bind = SUPER, C, exec, omarchy-focus-or-launch Code code

# Show keybindings (SUPER+?)
bind = SUPER, SLASH, exec, omarchy-menu-keybindings

# System Controls
bind = SUPER, L, exec, swaylock
bind = CTRL, SPACE, exec, omarchy-cmd-keyboard-layout-switch
bind = SUPER CTRL, G, exec, omarchy-cmd-gamemode
bind = SUPER, M, exec, omarchy-cmd-monitor-switch

# Lid switch (laptops)
bindl = , switch:on:Lid Switch, exec, swaylock && systemctl suspend
EOF
```

### Step 3: Reload Hyprland

```bash
hyprctl reload
```

---

## 7. Quick Reference Card

```
╔═══════════════════════════════════════════════════════════════════╗
║                    CUSTOM KEYBINDINGS REFERENCE                   ║
╠═══════════════════════════════════════════════════════════════════╣
║ WINDOW FOCUS                                                      ║
║   SUPER+hjkl              Focus window (left/down/up/right)       ║
║   ALT+TAB                 Cycle windows                           ║
╠═══════════════════════════════════════════════════════════════════╣
║ WINDOW MANAGEMENT                                                 ║
║   CTRL+ALT+hjkl           Move/snap window                        ║
║   SUPER+SHIFT+hjkl        Swap window positions                   ║
║   SUPER+Q                 Close window                            ║
║   SUPER+F                 Fullscreen                              ║
║   SUPER+T                 Toggle floating (omarchy default)       ║
╠═══════════════════════════════════════════════════════════════════╣
║ WORKSPACES                                                        ║
║   SUPER+[1-9,0]           Switch to workspace                     ║
║   SUPER+left/right        Previous/next workspace                 ║
║   SUPER+TAB               Next workspace (omarchy default)        ║
║   SUPER+CTRL+down         Jump to empty workspace                 ║
║   SUPER+SHIFT+[1-9,0]     Move window to workspace                ║
║   SUPER+ALT+h/l           Move window to prev/next workspace      ║
╠═══════════════════════════════════════════════════════════════════╣
║ APPLICATIONS (Focus-or-Launch)                                    ║
║   SUPER+RETURN            Terminal (Kitty)                        ║
║   SUPER+T                 Terminal (Ghostty)                      ║
║   SUPER+B                 Browser (Chromium)                      ║
║   SUPER+E                 File Manager (Dolphin)                  ║
║   SUPER+C                 Code Editor (VSCode)                    ║
║   SUPER+SPACE             App Launcher (Walker)                   ║
╠═══════════════════════════════════════════════════════════════════╣
║ SYSTEM                                                            ║
║   SUPER+?                 Show keybindings                        ║
║   SUPER+L                 Lock screen                             ║
║   SUPER+ESCAPE            System menu (power/logout)              ║
║   SUPER+M                 Monitor configuration                   ║
║   CTRL+SPACE              Switch keyboard layout                  ║
║   SUPER+CTRL+G            Toggle gamemode                         ║
╠═══════════════════════════════════════════════════════════════════╣
║ AESTHETICS                                                        ║
║   SUPER+SHIFT+SPACE       Toggle waybar                           ║
║   SUPER+CTRL+SPACE        Next background                         ║
║   SUPER+BACKSPACE         Toggle window transparency              ║
║   SUPER+SHIFT+BACKSPACE   Toggle gaps                             ║
╠═══════════════════════════════════════════════════════════════════╣
║ SCREENSHOTS                                                       ║
║   PRINT                   Screenshot with editing                 ║
║   SHIFT+PRINT             Screenshot to clipboard                 ║
║   ALT+PRINT               Screen recording menu                   ║
║   SUPER+PRINT             Color picker                            ║
╠═══════════════════════════════════════════════════════════════════╣
║ CLIPBOARD                                                         ║
║   SUPER+C                 Universal copy                          ║
║   SUPER+V                 Universal paste                         ║
║   SUPER+CTRL+V            Clipboard manager                       ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

**Document Version:** 1.1
**Created:** 2025-11-25
**Updated:** 2025-11-25 - Moved SUPER+K to SUPER+?
**Status:** Ready for Implementation
