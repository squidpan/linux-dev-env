# RUNBOOK — Pop!_OS MediaTek MT7922 Wi-Fi Fails After Suspend

## Purpose

Recover and prevent recurring Wi-Fi failures on a System76 Pangolin (`pang15`) running Pop!_OS 22.04 when the MediaTek MT7922 adapter fails to reconnect after suspend/resume.

## System

- Computer: System76 Pangolin
- DMI product version: `pang15`
- OS: Pop!_OS 22.04
- Kernel observed during diagnosis: `7.0.11-76070011-generic`
- Wi-Fi adapter: MediaTek MT7922
- PCI vendor/device: `14c3:7922`
- Kernel driver: `mt7921e`
- Interface: `wlp1s0`
- External monitor tested: Dell S3425DW over USB-C

## Symptoms

After suspend/resume, Wi-Fi commonly remained disconnected:

```text
wlp1s0  wifi  disconnected
ESSID:off/any
Access Point: Not-Associated
Power Management:off
```

The issue reproduced at home and on public Wi-Fi, and both with and without the Dell USB-C monitor attached.

## Initial Mitigation — Disable Wi-Fi Power Saving

Original NetworkManager setting:

```ini
[connection]
wifi.powersave = 3
```

Backup:

```text
/etc/NetworkManager/conf.d/default-wifi-powersave-on.conf.bak-20260814
```

Current setting:

```ini
[connection]
wifi.powersave = 2
```

Verify:

```bash
iwconfig wlp1s0 2>/dev/null | grep -i "Power Management"
```

Expected:

```text
Power Management:off
```

This did not solve the suspend/resume failure by itself.

## Manual Recovery

Reloading the MediaTek driver reliably restored Wi-Fi:

```bash
sudo modprobe -r mt7921e
sudo modprobe mt7921e
```

Local convenience alias:

```bash
alias rewifi='date;nmcli device status;iwconfig wlp1s0; sudo modprobe -r mt7921e;sudo modprobe mt7921e'
```

## System76 Update

On 2026-08-24:

```bash
sudo apt update
sudo apt full-upgrade
```

Relevant versions after upgrade:

```text
system76-driver          24.04.22~1787059990~22.04~78d6358
system76-firmware-daemon 1.0.78~1787059787~22.04~b3395ae
```

The package reported:

```text
INFO product_version: 'pang15'
INFO wifi_reload: Remove MediaTek WiFi PCI device on suspend and rescan on resume
INFO Skipping 'wifi_reload' as it was already applied
```

Installed hook:

```text
/usr/lib/systemd/system-sleep/system76-wifi-reload
```

## Root Cause

The System76 hook was intended to remove/reinitialize affected MediaTek Wi-Fi hardware around suspend/resume, but its device test originally matched only:

```sh
if [ "$device" = "0x7961" ] || [ "$device" = "0x0616" ]; then
```

The actual adapter reports:

```bash
cat /sys/bus/pci/devices/0000:01:00.0/vendor
cat /sys/bus/pci/devices/0000:01:00.0/device
```

Output:

```text
0x14c3
0x7922
```

Because `0x7922` was not included, the hook did not remove this adapter before suspend, so the resume rescan did not fully reinitialize it. This matches the observation that manually reloading `mt7921e` restored connectivity.

## Fix Applied

Back up the hook:

```bash
sudo cp /usr/lib/systemd/system-sleep/system76-wifi-reload \
  /usr/lib/systemd/system-sleep/system76-wifi-reload.bak-20260824
```

Add `0x7922`:

```bash
sudo sed -i \
's/\[ "$device" = "0x7961" \] || \[ "$device" = "0x0616" \]/[ "$device" = "0x7961" ] || [ "$device" = "0x0616" ] || [ "$device" = "0x7922" ]/' \
/usr/lib/systemd/system-sleep/system76-wifi-reload
```

Verify:

```bash
grep -n '0x7961\|0x0616\|0x7922' \
/usr/lib/systemd/system-sleep/system76-wifi-reload
```

Expected condition:

```sh
if [ "$device" = "0x7961" ] || [ "$device" = "0x0616" ] || [ "$device" = "0x7922" ]; then
```

## Verification

Suspend test:

```bash
sudo systemctl suspend
```

After wake:

```bash
nmcli device status
```

Expected final state:

```text
wlp1s0   wifi   connected
```

It is normal to briefly see:

```text
connecting (configuring)
```

Successful resume logs showed fresh device initialization:

```text
mt7921e ... enabling device
mt7921e ... ASIC revision: 79220010
mt7921e ... HW/SW Version ...
mt7921e ... WM Firmware Version ...
mt7921e ... wlp1s0: renamed from wlan0
...
authenticated
associated
```

Repeated tests passed with the Dell USB-C monitor both disconnected and connected, without needing `rewifi`.

## Future Update Warning

A future `system76-driver` update may overwrite the locally modified hook.

After each System76 driver update:

```bash
grep -n '0x7961\|0x0616\|0x7922' \
/usr/lib/systemd/system-sleep/system76-wifi-reload
```

If `0x7922` disappears, compare the newly installed hook with this runbook before reapplying the patch.

## Rollback

Restore the original hook:

```bash
sudo cp \
  /usr/lib/systemd/system-sleep/system76-wifi-reload.bak-20260824 \
  /usr/lib/systemd/system-sleep/system76-wifi-reload
```

Restore the original NetworkManager power setting if needed:

```bash
sudo cp \
  /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf.bak-20260814 \
  /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

## Troubleshooting

If Wi-Fi remains disconnected after resume:

```bash
nmcli device status
iwconfig wlp1s0
```

Fallback recovery:

```bash
sudo modprobe -r mt7921e
sudo modprobe mt7921e
```

Capture logs:

```bash
sudo journalctl -b --since "15 minutes ago" --no-pager | \
grep -iE 'system76-wifi|mt7921|wlp1s0|suspend|resume|sleep|PCI|NetworkManager|firmware|timeout|failed'
```

## Lessons Learned

- The problem was not limited to one access point or weak signal.
- Disabling Wi-Fi power saving alone did not solve it.
- The Dell USB-C monitor was not required to reproduce the failure.
- Reloading `mt7921e` consistently restored Wi-Fi.
- The System76 suspend hook was conceptually correct but did not match the actual `0x7922` device ID.
- Adding `0x7922` caused the hook to reinitialize the adapter automatically and repeated suspend/resume tests succeeded.

## Follow-Up

Consider reporting to System76:

- Model: Pangolin `pang15`
- Wi-Fi: MediaTek MT7922
- PCI ID: `14c3:7922`
- Driver: `mt7921e`
- Symptom: Wi-Fi remains disconnected after suspend/resume
- Stock hook checks `0x7961` and `0x0616`
- Adding `0x7922` restores automatic reconnect behavior
