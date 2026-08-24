# PROJECT STATUS — Pangolin MT7922 Wi-Fi Suspend Failure — 2026-08-24

## Status

**Working local fix verified.**

Recurring Wi-Fi loss after suspend/resume on System76 Pangolin `pang15` was traced to the System76 `wifi_reload` suspend hook not matching the laptop's actual MediaTek MT7922 PCI device ID.

## Root Cause

Actual adapter:

```text
Vendor: 0x14c3
Device: 0x7922
Driver: mt7921e
```

Stock hook matched only:

```text
0x7961
0x0616
```

Therefore the adapter was not removed before suspend and was not fully reinitialized on resume.

## Fix

Backup:

```text
/usr/lib/systemd/system-sleep/system76-wifi-reload.bak-20260824
```

Current expected condition:

```sh
if [ "$device" = "0x7961" ] || [ "$device" = "0x0616" ] || [ "$device" = "0x7922" ]; then
```

## Verification

Repeated suspend/resume tests passed:

- Dell S3425DW USB-C disconnected: PASS
- Dell S3425DW USB-C connected: PASS
- NetworkManager may briefly show `connecting (configuring)` before reaching `connected`
- Manual `rewifi` was not required in the successful patched tests
- Kernel logs showed fresh `mt7921e` initialization after resume

## Other Changes

Wi-Fi power saving remains disabled:

```ini
[connection]
wifi.powersave = 2
```

Relevant package versions:

```text
system76-driver          24.04.22~1787059990~22.04~78d6358
system76-firmware-daemon 1.0.78~1787059787~22.04~b3395ae
```

## Maintenance Warning

Future `system76-driver` upgrades may overwrite the local patch.

Verify after upgrades:

```bash
grep -n '0x7961\|0x0616\|0x7922' \
/usr/lib/systemd/system-sleep/system76-wifi-reload
```

## Fallback

```bash
sudo modprobe -r mt7921e
sudo modprobe mt7921e
```

## Next Actions

1. Continue normal use and monitor suspend/resume behavior.
2. Preserve the local patch until System76 ships an upstream correction covering `0x7922`.
3. Consider filing a System76 issue/support report.
4. Recheck the hook after every `system76-driver` update.
