#!/system/bin/sh
MODDIR=${0%/*}
until [ "$(getprop sys.boot_completed)" = 1 ]; do sleep 2; done; sleep 10
# junk packages that were installed before the module (first setup)
for p in $(cat $MODDIR/packages.txt); do pm list packages | grep -q "^package:$p$" && pm uninstall --user 0 $p >/dev/null 2>&1; done
# speed pack (once): 0.5x animations, 165 Hz, compile system apps fully
if [ ! -f /data/adb/zuxos_lite_firstrun ]; then
  settings put global window_animation_scale 0.5
  settings put global transition_animation_scale 0.5
  settings put global animator_duration_scale 0.5
  settings put system peak_refresh_rate 165.0
  settings put system min_refresh_rate 60.0
  touch /data/adb/zuxos_lite_firstrun
  (sleep 120; cmd package compile -m speed -f -a >/dev/null 2>&1) &
fi
# 165 Hz: ZUXOS resets the peak rate after boot, so re-apply it once things settle
(sleep 45; settings put system peak_refresh_rate 165.0; settings put system min_refresh_rate 60.0) &
# restore the last chosen mode
/system/bin/zuxmode $(cat /data/adb/zuxos_lite_mode 2>/dev/null || echo balanced) >/dev/null 2>&1
