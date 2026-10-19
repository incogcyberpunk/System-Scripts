# Android MTP on Arch Linux

## Tools

- **`aft-mtp-cli`** — command-line interface for browsing phone storage and transferring files. Run `aft-mtp-cli` and use its built-in `help` command; exact commands vary by version.
- **`aft-mtp-mount`** — exposes phone storage at a local mountpoint such as `~/mtp`, so tools like Yazi can browse it.
- **FUSE** (*Filesystem in Userspace*) — lets a userspace program provide a filesystem interface at a mountpoint. `aft-mtp-mount` uses FUSE to expose MTP storage as a directory.
- **`fusermount3`** — FUSE mount helper; use it to unmount the mounted phone.

## CLI workflow

```bash
aft-mtp-cli
```

Use `help` inside the CLI to list supported commands. Exit using the quit command shown there.

## Mount workflow

```bash
mkdir -p ~/mtp
aft-mtp-mount ~/mtp
```

Browse the phone from another terminal:

```bash
yazi ~/mtp
```

When finished, close apps using `~/mtp` and unmount:

```bash
fusermount3 -u ~/mtp
```

Check mount status:

```bash
findmnt ~/mtp
```

No output generally means the path is not mounted.

## `fusermount3 -u` vs `umount`

For an `aft-mtp-mount` FUSE mount, prefer:

```bash
fusermount3 -u ~/mtp
```

`umount ~/mtp` is the general Linux unmount command and may also work, depending on permissions and configuration. Neither command deletes the phone's files.

## Troubleshooting

- **Permission denied:** Check mountpoint permissions with `ls -ld ~/mtp` and `namei -l ~/mtp`.
- **Busy mount:** Close programs using `~/mtp`, or inspect them with `fuser -vm ~/mtp`, then retry `fusermount3 -u ~/mtp`.
- **Device access conflicts:** Avoid using `aft-mtp-cli` and `aft-mtp-mount` on the same phone simultaneously.

## Quick reference

| Task | Command |
|---|---|
| CLI help | `aft-mtp-cli --help` |
| Start CLI | `aft-mtp-cli` |
| Mount help | `aft-mtp-mount --help` |
| Mount phone | `aft-mtp-mount ~/mtp` |
| Browse with Yazi | `yazi ~/mtp` |
| Unmount | `fusermount3 -u ~/mtp` |
| Check mount | `findmnt ~/mtp` |
