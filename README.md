# Lenovo Legion Y700 Gen 3 (TB321FU): bootloader unlock + Armada OS install

A tested, step-by-step Windows guide to unlocking the bootloader of the Lenovo
Legion Y700 Gen 3 (2025, **TB321FU**, Chinese ZUI firmware) and flashing the
**Armada** custom ROM. We didn't make Armada; all credit goes to its developers
(see *Credits*). What's here is the procedure and helper scripts that worked for us,
including the problems we hit and how we got past them.

> ⚠️ Unlocking **erases everything** on the tablet. Back up first. You do this at your own risk.

## What you need

- Windows PC, a good USB-C cable
- [Android platform-tools](https://developer.android.com/tools/releases/platform-tools) (adb/fastboot); put them in `platform-tools\` next to the scripts
- The **Google USB Driver** (Android Bootloader Interface). Without it the tablet is
  not seen in fastboot after `adb reboot bootloader`. Install it from Device Manager
  → *Update driver* → *Let me pick* → *Android Bootloader Interface*.
- The Armada release files for TB321FU: `boot.img`, `super.img`, `userdata.simg`
  (large files may be split into `userdata.simg.part1..N`)

## 1. Prepare the tablet

1. Settings → About → tap the build number 7 times to enable Developer options.
2. Developer options → enable **OEM unlocking** and **USB debugging**.
3. Plug in the PC and accept the USB debugging prompt.
4. `scripts\1_check_tablet.bat` should list the device.

## 2. Make your `sn.img` (unlock file)

ZUI (China firmware) devices need an `sn.img` built from **your own** serial number.
It is unique per tablet. **Never share yours, and don't use someone else's.**

- Get the serial: `fastboot getvar serialno` (in fastboot) or `adb shell getprop ro.serialno`.
- Build the file with one of the public generators for Lenovo ZUI devices, e.g. the
  [lenovoubl tool](https://github.com/mlgmxyysd/lenovoubl) or the method on the
  postmarketOS wiki page *Unlocking Bootloaders/Lenovo ZUI*.
  The result is a ~5 KB file that starts with `ANDROID!` and contains your serial.
- Put it next to the scripts as `sn.img`.

## 3. Unlock

1. `scripts\4_to_fastboot.bat` (or power off, then hold **Vol-Down + Power**).
   You should see the fastboot *START* screen.
2. `scripts\5_unlock.bat` runs:
   ```
   fastboot flash unlock sn.img
   fastboot oem unlock-go
   ```
   Confirm on the tablet with the volume keys and power. USB may drop during
   `unlock-go`; that's fine. The tablet wipes itself and reboots.
3. After the wipe, enable USB debugging again. `scripts\6_status.bat` should report
   `unlocked: yes`.

## 4. Flash Armada

1. If `userdata.simg` came split, join it: `scripts\7_join_userdata.bat`
   (a plain `copy /b part1+part2+...`).
2. `scripts\8_flash_armada.bat` sends the tablet to the bootloader if needed, checks
   `unlocked=yes` (and aborts if not), then:
   ```
   fastboot flash boot_<slot> boot.img
   fastboot flash super super.img
   fastboot -S 700M flash userdata userdata.simg
   fastboot reboot
   ```
   The userdata flash takes several minutes. The first boot is slow.

Every script writes a `log_*.txt` next to itself, so you can check what happened.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| `fastboot devices` is empty after `adb reboot bootloader` | Install the Google USB driver as *Android Bootloader Interface* |
| `oem unlock-go` disconnects | Normal; check `fastboot getvar unlocked` after the reboot |
| Can't get back to fastboot after the unlock wipe | Re-enable USB debugging, then `adb reboot bootloader`, or use Vol-Down + Power |
| Bootloop after flashing | Re-flash all three images; make sure the `boot` slot matches `current-slot` |

## Going back to stock

Flash the official ZUI firmware with Lenovo's *Rescue and Smart Assistant* (LMSA)
or fastboot. You can relock afterwards only with firmware that has an equal or newer
rollback index.

## Credits and sources

- **Armada OS developers**: the ROM itself (add the link to the release you used here)
- [mlgmxyysd/lenovoubl](https://github.com/mlgmxyysd/lenovoubl): Lenovo bootloader unlock (sn.img) tool
- postmarketOS wiki, *Unlocking Bootloaders/Lenovo ZUI*: documentation of the ZUI sn.img unlock
- [DroidWin: How to unlock bootloader on Lenovo Legion Y700](https://droidwinom.pages.dev/posts/how-to-unlock-bootloader-on-lenovo-legion-y700) and
  [How to create the SN file](https://droidwinom.pages.dev/posts/how-to-create-sn-file-for-lenovo-bootloader-unlocking)
- [Android platform-tools](https://developer.android.com/tools/releases/platform-tools)

License of the scripts: MIT.
