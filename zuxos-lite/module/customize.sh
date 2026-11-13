ui_print "- ZUXOS Lite: removing junk apps (systemless, undo by disabling this module)"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/action.sh 0 0 0755
set_perm $MODPATH/system/bin/zuxmode 0 0 0755
