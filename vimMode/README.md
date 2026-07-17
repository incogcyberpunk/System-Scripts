# vim-mode-toggle.sh

A small bash script that toggles system-wide vim-style navigation keys (`h/j/k/l` → arrow keys) using [`keyd`](https://github.com/rvaiya/keyd), with desktop notifications to confirm the current state.

## What it does

Running the script flips between two states, tracked in `/tmp/vimMode.txt`:

- **Enabling (state `0` → `1`)**: Rebinds `h`, `j`, `k`, `l` to left/down/up/right, and `esc` to `esc`, via `keyd bind`. Sends a critical, persistent `notify-send` notification ("Vim Mode: Enabled").
- **Disabling (state `1` → `0`)**: Runs `keyd bind reset` to restore normal keyboard behavior. Sends a low-priority notification ("Vim Mode: Disabled") that auto-dismisses after 1 second.

State is persisted in `/tmp/vimMode.txt` so the script knows what to do on the next run — it's meant to be bound to a single hotkey that toggles the mode on and off.

The `-h string:x-canonical-private-synchronous:vimMode` flag on both notifications ensures each new toggle notification replaces the previous one instead of stacking up.

## Requirements

- [`keyd`](https://github.com/rvaiya/keyd) installed and running as a system service
- `notify-send` (usually provided by `libnotify-bin` / `libnotify`)
- **Permissions**: `keyd bind` talks to the keyd control socket, which requires either:
  - Your Linux user being a member of the `keyd` group, **or**
  - Running the script with `sudo`

  To add yourself to the `keyd` group:
  ```bash
  sudo usermod -aG keyd $USER
  ```
  Then log out and back in (or start a new session) for the group change to take effect.

## Installation

1. Save the script somewhere on your `PATH`, e.g. `~/.local/bin/vim-mode-toggle.sh`
2. Make it executable:
   ```bash
   chmod +x ~/.local/bin/vim-mode-toggle.sh
   ```
3. Bind it to a hotkey in your window manager / compositor config (e.g. Hyprland, Sway, i3) so you can toggle vim mode on and off with a keypress.

## Usage

```bash
./vim-mode-toggle.sh
```

Run it once to enable vim navigation mode, run it again to disable it. No arguments needed — it reads and writes its own state file.

If your user isn't in the `keyd` group:

```bash
sudo ./vim-mode-toggle.sh
```

## Shell safety options

The script uses `set -uo pipefail` near the top, which enables two safety behaviours:

- **`-u` (nounset)**: referencing any unset or undefined variable immediately exits the script with an error, rather than silently expanding it to an empty string. This makes typos in variable names loud and obvious rather than silent and confusing.
- **`-o pipefail`**: if any command in a pipeline fails, the whole pipeline reports failure using the exit code of the rightmost failing command — not just the last one. Without this, a failing `awk` in a pipeline would go unnoticed as long as the final command succeeded.

`-e` (exit on any non-zero command) is intentionally not set here — the `if keyd bind ...` blocks handle `keyd` failures themselves, and `-e` would exit the script before that logic could run.

## Notes / caveats

- State is stored in `/tmp/vimMode.txt`, which is cleared on reboot (typical for `/tmp` on most distros) — the script will start assuming vim mode is off after a reboot, regardless of the last state before shutdown.
- If `keyd bind` fails (e.g. due to permissions or `keyd` not running), the script silently skips the notification and state update rather than erroring out loudly — worth checking `keyd`'s status if toggling doesn't seem to work.
- The bindings applied (`h/j/k/l` → arrows, `esc` → `esc`) are system-wide via keyd, not app-specific — they'll apply everywhere until disabled.
