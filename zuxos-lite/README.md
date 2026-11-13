# ZUXOS Lite: faster stock ZUXOS 1.5 (Android 16) for the Legion Y700 Gen 3

Stock Chinese ZUXOS **1.5.10.184** with root and a small Magisk module that removes junk
while **keeping** Lenovo's gaming features, PC/desktop mode and stylus support.

## What the module does (`module/`)
- **Debloat (systemless):** weather, Smart Connect, Vantage, Phone Clone, Lenovo notes/calendar/
  recorder/calculator, the Chinese AI assistant + AI Lens, network manager, partner auto-installer,
  printing, screensavers and live wallpapers (`removed.txt`). Undo by removing the module.
- **Speed tweaks** (`system.prop`, `service.sh`): animation, ART/dexopt and scheduler settings;
  re-applies 165 Hz after boot (ZUXOS resets it to 120 Hz).
- **Modes:** `zuxmode performance|balanced|battery` from a terminal, or tap **Action** on the module
  in Magisk to cycle.

## Install (wipes the tablet; bootloader must be unlocked, see the main guide)
1. Firmware: CN full OTA `TB321FU_CN_OPEN_USER_Q00002.0_W_ZUI_17.5.10.184_ST_260208` from Lenovo's CDN
   (`https://ota-cdn.lenovo.com/firmware/202629135222236-2821.zip`). Extract `payload.bin` with
   [payload-dumper-go](https://github.com/ssut/payload-dumper-go) into `images/`.
2. Root: patch `images/init_boot.img` with [Magisk](https://github.com/topjohnwu/Magisk) → `init_boot_magisk.img`.
3. Dynamic partitions: make `super_empty.img` with `lpmake` (super 13958643712, group
   `qti_dynamic_partitions_a/b` 13954449408, virtual A/B, 3 metadata slots).
4. Tablet in fastboot, run `FLASH_ZUXOS_LITE.bat` (firmware on both slots → wipe-super → fastbootd for
   the logical partitions → wipe data).
5. After setup: install Magisk, flash the module zip (zip the `module/` folder), reboot.
6. Optional: Google Play — install `Phonesky.apk` from [MindTheGapps](https://github.com/MindTheGapps) as an
   update with `adb install`; launcher — [Lawnchair](https://github.com/LawnchairLauncher/lawnchair)
   (desktop/PC mode keeps working; set Lawnchair as home in Settings).
