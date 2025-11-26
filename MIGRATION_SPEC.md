# Migration Specification: arch-config → omarchy

This document outlines the features and configurations from the HyDe-based arch-config that need to be migrated to the omarchy distribution.

## Overview

The arch-config is a HyDe (Hyprland Desktop Environment) based setup with custom configurations and scripts. This spec identifies features to integrate into the omarchy system while maintaining omarchy's design principles (modular installation, theme system, migration-based updates).

---

## 1. Monitor Management System

### Current State (arch-config)
- **Multiple monitor configurations** in `hypr/monitorconfigs/`:
  - `mirror.conf` - Mirror display to TV
  - `extend.conf` - Extended desktop
  - `only1.conf` - Primary monitor only
  - `only2.conf` - Secondary monitor only
- **Rofi-based switcher** (`rofimonitor.sh`) - GUI menu to switch between monitor configs
- **Symlink-based activation** - Selected config symlinked to `monitors.conf`

### Migration Tasks
- [ ] Create `config/hypr/monitorconfigs/` directory structure
- [ ] Port monitor configuration files to omarchy format
- [ ] Integrate `rofimonitor.sh` into omarchy bin utilities as `omarchy-cmd-monitor-switch`
- [ ] Add keybinding `$mainMod, M` for monitor configuration menu
- [ ] Support PNG icons for rofi menu (if using rofi in omarchy)
- [ ] Create migration to deploy monitor configs to existing installations

**Default Monitor Config (from arch-config):**
```conf
monitor = DP-1, 2560x1440@144, 0x0, 1              # LG Ultragear
monitor = HDMI-A-1, 1920x1080@60, 2560x-220, 1, transform, 3  # LG 24' vertical
monitor = HDMI-A-2, 1920x1080@60, -1920x0, 1.5, mirror, DP-1  # TV Philips Roku

workspace=1,monitor:DP-1
workspace=10,monitor:HDMI-A-1
exec-once=xrandr --output DP-1 --primary
```

---

## 2. Custom Keybindings

### Current State (arch-config)
Custom keybindings not present in default HyDe/omarchy:

- **Monitor switching**: `$mainMod, M` → monitor config menu
- **Window management**:
  - `$mainMod CTRL, k/j` → move focus up/down
  - `$mainMod SHIFT CTRL, k/j` → move window left/right
  - `$mainMod SHIFT, l/h` → move window to workspace +1/-1
- **Workspace navigation**:
  - `$mainMod, right/left` → next/previous workspace
  - `$mainMod CTRL, down` → jump to first empty workspace
- **Media keys**: Full XF86 media key support (audio, brightness)
- **Screenshot shortcuts**:
  - `$mainMod SHIFT, 4` → frozen screen snip
  - `$mainMod SHIFT, 3` → print focused monitor
  - `print` → print all monitors
- **Custom toggles**:
  - `$CONTROL, SPACE` → keyboard layout switch
  - `$mainMod ALT, G` → gamemode toggle (disable effects)
  - `CONTROL, ESCAPE` → toggle waybar
- **Application launchers**:
  - `$mainMod, T` → terminal (kitty)
  - `$mainMod, F` → browser (chromium)
  - `$mainMod, E` → file manager (dolphin)
- **Lid switch**: Auto-lock and suspend on laptop lid close

### Migration Tasks
- [ ] Review omarchy's existing keybindings in `default/hypr/bindings/`
- [ ] Create `default/hypr/bindings/custom.conf` for custom bindings
- [ ] Implement bindings that don't conflict with omarchy defaults
- [ ] Update `omarchy-cmd-gamemode` or create equivalent for performance toggle
- [ ] Document keybinding conflicts/changes in migration guide

---

## 3. Window Rules & Opacity Settings

### Current State (arch-config)
Extensive window rules for opacity and floating behavior:

**Opacity Rules:**
- Firefox/Brave: 0.90
- VSCode: 0.80
- Kitty: 0.80
- Dolphin: 0.80
- System tools (pavucontrol, blueman, etc.): 0.80/0.70
- Steam: 1.00 (no transparency for games)
- Spotify: 0.70
- Discord/ArmCord: 0.80
- Various GTK apps: 0.80

**Float Rules:**
- File manager dialogs (copy/progress)
- Firefox Picture-in-Picture
- System monitors (btop, htop)
- System utilities (pavucontrol, blueman, etc.)

**Layer Rules:**
- Blur for rofi, notifications, swaync

### Migration Tasks
- [ ] Review omarchy's existing window rules
- [ ] Port opacity settings to omarchy format
- [ ] Consider making opacity theme-specific (add to theme configs)
- [ ] Ensure layer rules for blur are compatible with omarchy themes
- [ ] Test window rules don't conflict with omarchy defaults
- [ ] Create migration to deploy window rules

---

## 4. User Preferences & Customizations

### Current State (arch-config)
`userprefs.conf` contains:

**Decoration:**
- Rounding: 5px
- Blur enabled: size 7, passes 4
- Optimized blur settings

**Animations:**
- Custom bezier curve: `0.10, 0.9, 0.1, 1.05`
- Tuned animation speeds

**Hyprexpo Plugin:**
- 2 column layout
- Gap size: 5
- 4-finger gesture enabled
- Swipe down to activate

### Migration Tasks
- [ ] Determine which settings should be:
  - Theme-specific (go in theme configs)
  - User defaults (go in default configs)
  - Per-user overrides (documented for users to set)
- [ ] Integrate blur/rounding settings into omarchy themes if needed
- [ ] Port hyprexpo configuration
- [ ] Ensure hyprexpo plugin is installed (see Hyprland Plugins below)

---

## 5. Custom Scripts & Utilities

### Current State (arch-config)
Custom scripts in `assets/bin/`:

**rofimonitor.sh** (1536 bytes)
- Displays monitor configs with icons in rofi
- Symlinks selected config to `monitors.conf`
- Sends notification on selection

**dualsenseinfo.sh** (843 bytes)
- Monitors PS5 DualSense controller battery
- Returns JSON for waybar
- Shows battery percentage and charging state
- Icon changes based on battery level

### Migration Tasks
- [ ] Port `rofimonitor.sh` → `omarchy-cmd-monitor-switch`
  - Adapt to omarchy's notification system (mako/dunst)
  - Follow omarchy bin script conventions
  - Add to `bin/` directory
- [ ] Port `dualsenseinfo.sh` → `omarchy-cmd-dualsense-info`
  - Ensure `dualsensectl` package dependency
  - Add to `bin/` directory
- [ ] Create migration to:
  - Install new scripts
  - Add `dualsensectl` package
- [ ] Update documentation for new utilities

---

## 6. Waybar Customizations

### Current State (arch-config)
Custom waybar modules:

**Custom Modules:**
- `custom/dualsenseinfo` - DualSense controller battery
  - Script: `dualsenseinfo.sh`
  - Interval: 5 seconds
  - Format: icon + percentage

**Module Layout:**
- Modules-right includes: `battery`, `custom/dualsenseinfo`, other modules
- CPU/Memory/GPU info modules
- Hyprland language switcher

**Window Title Rewrites:**
- Custom window title formatting for apps
- Icons for Firefox, VSCode, Dolphin, Spotify, Steam, etc.

### Migration Tasks
- [ ] Review omarchy's waybar theme structure
- [ ] Add `custom/dualsenseinfo` module to waybar themes
- [ ] Update all theme waybar configs to include dualsense module
- [ ] Port window title rewrite rules if not already in omarchy
- [ ] Test waybar module compatibility with omarchy themes
- [ ] Create migration to update waybar configs

---

## 7. Hyprland Plugins

### Current State (arch-config)
Installed plugins via `hyprpm`:

- **hyprland-plugins** (official)
  - `hyprexpo` - Workspace overview/expose (enabled)
- **hycov** - Window overview (commented out - doesn't work)

### Migration Tasks
- [ ] Add hyprland plugin dependencies to omarchy packages:
  - `cpio`, `meson`, `cmake`, `hyprwayland-scanner`
- [ ] Create `omarchy-install-hypr-plugins` script
- [ ] Add to first-run or make optional install
- [ ] Configure hyprexpo with settings from userprefs
- [ ] Add keybinding for hyprexpo (currently commented: `$mainMod, up`)
- [ ] Document hyprexpo usage in omarchy docs
- [ ] Test plugin compatibility with omarchy's Hyprland setup

---

## 8. Display Manager & Login

### Current State (arch-config)
- **GDM (GNOME Display Manager)** instead of SDDM
- Disabled: `sddm.service`
- Enabled: `gdm.service`

**Rationale:** SDDM customization was abandoned in favor of GDM

### Migration Tasks
- [ ] **Decision Required**: Should omarchy support GDM as alternative to SDDM?
  - Option A: Keep SDDM only (omarchy default)
  - Option B: Add optional GDM support
  - Option C: Make display manager selectable during install
- [ ] If supporting GDM:
  - Add GDM to optional packages
  - Create `omarchy-install-gdm` script
  - Handle service switching safely
  - Add to documentation
- [ ] Create migration for users who want to switch

**Note:** This is a significant change to omarchy's login system design. Needs discussion.

---

## 9. Chrome/Chromium Wayland Fixes

### Current State (arch-config)
`chrome-flags.conf` contains Wayland optimization flags:

```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
--disable-features=WaylandFractionalScaleV1
```

**Purpose:** Fixes jittery animations in Chromium-based browsers on Wayland

### Migration Tasks
- [ ] Determine where chromium flags should be stored in omarchy
  - Option: `~/.config/chromium-flags.conf`
  - Option: `~/.config/chrome-flags.conf` (for both Chrome/Chromium)
- [ ] Add chromium flags to omarchy config deployment
- [ ] Test if omarchy already has Wayland optimizations
- [ ] Document in browser setup section
- [ ] Create migration to deploy flags file

---

## 10. Package Dependencies

### Current State (arch-config)
Additional packages from `arch_pacman_packages.txt`:

**Core Packages:**
- `hyprland`, `git`, `chromium`
- `cpio`, `meson`, `cmake`, `hyprwayland-scanner` (for hyprpm)
- `flatpak`, `gdm`

**Additional Packages:** (would need full file review)

**Flatpak Apps:**
- `net.lutris.Lutris` - Gaming platform
- `io.missioncenter.MissionCenter` - System monitor

### Migration Tasks
- [ ] Compare arch-config packages with omarchy packages
- [ ] Identify packages not in omarchy base/other packages
- [ ] Add missing packages to appropriate omarchy package lists
- [ ] Add flatpak setup to omarchy if not present
- [ ] Create migration for new package installations
- [ ] Document optional packages (gaming, etc.)

---

## 11. Grub Theme

### Current State (arch-config)
- **Tela Theme** installed for GRUB
- Installation via vinceliuice/grub2-themes
- Theme: `tela`, Screen: `2k`

### Migration Tasks
- [ ] **Decision Required**: Should omarchy include GRUB theming?
  - May be out of scope (bootloader is pre-omarchy)
- [ ] If supporting:
  - Create `omarchy-install-grub-theme` optional script
  - Document in post-install customization
- [ ] Alternatively: Document external GRUB theming in wiki

---

## 12. Other Configuration Files

### Current State (arch-config)
Files to review for migration:

- `hypr/animations.conf` - Custom animation settings
- `waybar/config.ctl` - Waybar control config
- `waybar/modules/` - Custom waybar modules

### Migration Tasks
- [ ] Review all config files for unique settings
- [ ] Identify any HyDe-specific configs that need porting
- [ ] Ensure compatibility with omarchy's config system
- [ ] Test layered config overrides work correctly

---

## Migration Strategy

### Phase 1: Core Infrastructure (High Priority)
1. Monitor management system (rofimonitor script + configs)
2. Custom scripts (dualsenseinfo, monitor switch)
3. Hyprland plugins support (hyprexpo)
4. Package dependencies

### Phase 2: Configuration & Keybindings (Medium Priority)
1. Custom keybindings integration
2. Window rules and opacity settings
3. User preferences (blur, animations)
4. Waybar customizations

### Phase 3: Optional Features (Low Priority)
1. Chrome/Chromium Wayland flags
2. GDM support (if decided)
3. GRUB theming (if decided)
4. Additional package installations

### Phase 4: Testing & Documentation
1. Test all migrated features
2. Create migration scripts for existing installations
3. Update omarchy documentation
4. Document breaking changes or new features

---

## Implementation Guidelines

### Omarchy Integration Principles
1. **Respect omarchy's architecture**: Use bin utilities, config layering, theme system
2. **Migration-based updates**: Create timestamped migrations for all changes
3. **Idempotency**: All scripts must be safely re-runnable
4. **User choice**: Make features optional where appropriate
5. **Documentation**: Update CLAUDE.md and README.md as features are added
6. **Theme compatibility**: Ensure features work across all 14 omarchy themes

### File Organization
- Scripts → `bin/omarchy-*`
- Configs → `config/`, `default/`
- Migrations → `migrations/TIMESTAMP.sh`
- Docs → Update `CLAUDE.md`, `README.md`

### Testing Checklist
- [ ] Fresh install works
- [ ] Existing install migration works
- [ ] No conflicts with existing omarchy features
- [ ] All themes support new features
- [ ] Scripts are idempotent
- [ ] Documentation is accurate

---

## Open Questions

1. **Display Manager**: Should omarchy support GDM as an alternative to SDDM?
2. **Keybinding Conflicts**: Which keybindings should take precedence if conflicts exist?
3. **Theme Scope**: Should opacity/blur be global or theme-specific?
4. **Plugin Management**: Should hyprland plugins be installed by default or optional?
5. **Package Scope**: Which packages from arch-config are universally useful vs. personal preference?

---

## Notes

- Arch-config was built on HyDe, which has different architecture than omarchy
- Many HyDe scripts (in `$scrPath`) will need omarchy equivalents
- Some features may already exist in omarchy in different forms
- Priority should be given to features that enhance core functionality vs. aesthetic preferences
- User-specific configs (monitor positions, etc.) should remain user-configurable

---

**Document Version:** 1.0
**Created:** 2025-11-25
**Last Updated:** 2025-11-25
**Status:** Draft - Awaiting Review
