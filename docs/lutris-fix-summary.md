# Lutris Fix Summary

## Problem Identified

- You had Lutris installed via pacman, which installed the Lutris Python modules into the system Python 3.13.7's site-packages directory (`/usr/lib/python3.13/site-packages/lutris`)
- However, you had `mise` configured globally with `python = "latest"` in `~/.config/mise/config.toml`, which installed Python 3.14.0
- When you ran `lutris`, the shebang `#!/usr/bin/env python3` was resolving to mise's Python 3.14.0 (not the system Python 3.13.7)
- Python 3.14.0 didn't have the lutris modules, causing the error: "No module named 'lutris'"

## Solution Applied

1. **Edited** `/home/cost/.config/mise/config.toml` to remove the global Python configuration
   - Changed from:
     ```toml
     [tools]
     node = "lts"
     python = "latest"
     ```
   - Changed to:
     ```toml
     [tools]
     node = "lts"
     ```

2. **Result:** Python is no longer managed globally by mise, so your system will now use `/usr/bin/python3` (version 3.13.7) by default, which has the lutris modules installed

3. **Per-Project Python:** You can still use Python 3.14.0 (or any version) in specific projects by running `mise use python@3.14.0` inside a project directory, which creates a local `.tool-versions` file

## Next Step Required

You need to reload your shell (close and reopen terminal, or run `exec $SHELL`) for the changes to take effect. After that, `lutris` should work correctly.

## How to Use Per-Project Python

When you need Python 3.14 (or any version) in a specific project directory:

```bash
cd /path/to/your/project
mise use python@3.14.0    # Creates/updates .tool-versions
python --version          # Shows 3.14.0
```

When you leave that directory:

```bash
cd ~
python --version          # Shows system Python (3.13.7)
```
