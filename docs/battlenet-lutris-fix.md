# Battle.net Lutris Installation Fix

## Problem

When attempting to install Battle.net through Lutris, the installation failed with the following error:

```
wine: could not load kernel32.dll, status c0000135
Exit with return code 13568
```

Additionally, Wine prefix creation would hang indefinitely on the message:
"The Wine configuration in /home/cost/Games/battlenet is being updated, please wait..."

## Root Causes

1. **Missing 32-bit Wine dependencies** - Critical libraries required for 32-bit Windows applications were not installed
2. **Wine-GE 8-26 hang bug** - This version has a known issue where `rundll32.exe` hangs during prefix initialization when running the INF installation step

## Solution

### Step 1: Install Missing 32-bit Libraries

Install the required 32-bit Wine dependencies:

```bash
sudo pacman -S --needed lib32-gnutls lib32-mpg123 lib32-openal lib32-v4l-utils lib32-gst-plugins-base-libs lib32-sdl2
```

**Note:** `lib32-libgphoto2` may not be available but is not critical for Battle.net (only needed for camera/scanner support)

The most critical package is **lib32-gnutls**, which provides TLS/HTTPS support that Battle.net requires.

### Step 2: Use System Wine Instead of Wine-GE

Wine-GE 8-26 has a hanging bug during prefix initialization. The system Wine (10.19) does not have this issue.

#### Method A: Change Runner in Lutris (Recommended)

1. In Lutris, right-click on Battle.net entry
2. Click **Configure**
3. Go to **Runner options** tab
4. Change **Wine version** from `wine-ge-8-26-x86_64` to **System (10.19)**
5. Click **Save**
6. Retry installation

#### Method B: Manually Create Prefix with System Wine

If Lutris still has issues, create the prefix manually first:

```bash
# Remove any incomplete prefix
rm -rf /home/cost/Games/battlenet

# Create prefix with system Wine
WINEPREFIX=/home/cost/Games/battlenet WINEDLLOVERRIDES="mscoree,mshtml=" WINEARCH=win64 wineboot -u

# Wait for completion (about 30 seconds)
# Then proceed with Lutris installation
```

### Step 3: Run Battle.net Installer

After completing steps 1 and 2, the Battle.net installation through Lutris should work without hanging or errors.

## What Was Fixed

- ✅ Installed missing 32-bit Wine dependencies (especially lib32-gnutls)
- ✅ Avoided Wine-GE 8-26 hang bug by using system Wine 10.19
- ✅ Created fully functional Wine prefix with both 64-bit and 32-bit support
- ✅ kernel32.dll and all system files now load correctly

## Alternative: Upgrade Wine-GE

If you prefer to use Wine-GE instead of system Wine, install a newer version:

```bash
cd ~/.local/share/lutris/runners/wine/
wget https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton9-20/wine-ge-9-20-x86_64.tar.xz
tar -xf wine-ge-9-20-x86_64.tar.xz
rm wine-ge-9-20-x86_64.tar.xz
```

Then select `wine-ge-9-20-x86_64` in Lutris runner options.

## Issue #2: Battle.net GUI Stuck Loading / Experimental WoW64 Errors

After installation, Battle.net may start but the login GUI appears stuck loading, with console errors like:

```
wine: Unhandled exception 0x80000003 in thread 650 at address 6ADD00E1
err:environ:init_peb starting L"C:\\windows\\syswow64\\winedbg.exe" in experimental wow64 mode
```

### Root Cause

Wine 10.19 (system Wine) has experimental WoW64 (Windows-on-Windows 64-bit) support that's unstable with some applications like Battle.net.

### Solution: Configure Wine Debugger and Environment

Disable the Wine debugger and configure proper settings:

```bash
# Disable Wine crash dialogs
WINEPREFIX=/home/cost/Games/battlenet wine reg add 'HKCU\Software\Wine\WineDbg' /v ShowCrashDialog /t REG_DWORD /d 0 /f

# Configure Wine debug output
WINEPREFIX=/home/cost/Games/battlenet wine reg add 'HKCU\Software\Wine\Debug' /v RelayExclude /t REG_SZ /d 'ntdll.RtlNtStatusToDosErrorNoTeb;ntdll.RtlGetLastWin32Error;ntdll.RtlSetLastWin32Error' /f
```

Then launch Battle.net through Lutris with additional environment variables:

1. In Lutris, right-click Battle.net → **Configure**
2. Go to **System options** tab
3. Scroll to **Environment variables**
4. Add these variables:
   - `WINEDEBUG` = `-all`
   - `DXVK_LOG_LEVEL` = `none`

### Recommended Solution: Use Proton-GE

Proton-GE has stable WoW64 support and works best with Battle.net:

**If switching from Wine to Proton:**

1. Kill all Wine processes: `pkill -f wine`
2. Remove the incompatible prefix: `rm -rf /home/cost/Games/battlenet`
3. In Lutris, right-click Battle.net → **Configure**
4. Change **Runner** from Wine to **Proton**
5. Select **GE-Proton** version
6. **Save** and reinstall Battle.net

**For fresh installation:**

1. In Lutris, install Battle.net
2. When prompted for runner, choose **Proton** (not Wine)
3. Select **GE-Proton** version
4. Complete installation

This avoids the Wine 10.19 experimental WoW64 issues entirely.

## Installing Hearthstone Deck Tracker

Once Battle.net is working with Proton-GE, you can install Hearthstone Deck Tracker in the same Wine prefix.

### Installation Steps

1. **Download the latest HDT installer:**

```bash
# Create temp directory
mkdir -p /tmp/hdt && cd /tmp/hdt

# Download HDT installer
curl -L -o HDT-Installer.exe https://github.com/HearthSim/HDT-Releases/releases/download/v1.48.9/HDT-Installer.exe
```

2. **Run the installer using Proton:**

```bash
WINEPREFIX=/home/cost/Games/battlenet /home/cost/.local/share/lutris/runners/proton/ge-proton/files/bin/wine /tmp/hdt/HDT-Installer.exe
```

3. **Wait for installation to complete** (you'll see the installer window and HDT will launch briefly)

### Add HDT to Lutris

1. In Lutris, click the **+** button (top-left) → **Add Game**
2. Fill in:
   - **Name**: Hearthstone Deck Tracker
   - **Runner**: Proton
   - **Proton version**: ge-proton (same as Battle.net)
3. **Game options** tab:
   - **Executable**: Browse to:
     `/home/cost/Games/battlenet/drive_c/users/steamuser/AppData/Local/HearthstoneDeckTracker/HearthstoneDeckTracker.exe`
   - **Wine prefix**: `/home/cost/Games/battlenet`
4. Click **Save**

### Alternative: Command Line Launch

You can also run HDT directly from terminal:

```bash
WINEPREFIX=/home/cost/Games/battlenet /home/cost/.local/share/lutris/runners/proton/ge-proton/files/bin/wine "/home/cost/Games/battlenet/drive_c/users/steamuser/AppData/Local/HearthstoneDeckTracker/HearthstoneDeckTracker.exe" &
```

### Usage

1. Launch Battle.net from Lutris
2. Launch Hearthstone Deck Tracker (either from Lutris or command line)
3. Start Hearthstone from Battle.net
4. HDT will automatically detect and track your games

Both applications share the same Wine prefix (`/home/cost/Games/battlenet`), allowing them to interact properly.

## Summary

The issue was caused by missing 32-bit libraries combined with a Wine-GE version-specific bug. Switching to system Wine (or a newer Wine-GE) after installing the required libraries resolves both problems. However, system Wine 10.19 has experimental WoW64 that can cause GUI issues, which requires additional configuration or switching to Proton-GE.

**Final working setup:**
- 32-bit libraries installed (lib32-gnutls, lib32-mpg123, etc.)
- Proton-GE runner for Battle.net
- Same Proton-GE prefix shared with Hearthstone Deck Tracker
