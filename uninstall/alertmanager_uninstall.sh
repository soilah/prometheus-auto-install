#!/bin/bash

source ./utils.sh

check_root
check_local_package alertmanager absent


#### First stop service
info "Stopping and disabling alertmanager service..."
run_notify "systemctl stop alertmanager &> /dev/null"
run_notify "systemctl disable alertmanager"
ok "Done"


USER_ANS=$(prompt_yes_no 'Do you want to remove alertmanager user? (yes/no): ')
if [ $USER_ANS == 'yes' ]; then
	#### Remove prometheus user 
	info "Removing alertmanager user..."
	run_notify "deluser alertmanager"
	ok "Done"
fi


info "Deleting directories and binaries..."
CONF_DIR_ANS=$(prompt_yes_no 'Do you want to remove alertmanager config directory? (yes/no): ')
if [ $CONF_DIR_ANS == 'yes' ]; then
	rm -rf /etc/alertmanager
fi
LIB_DIR_ANS=$(prompt_yes_no 'Do you want to remove alertmanager lib directory? (yes/no): ')
if [ $LIB_DIR_ANS == 'yes' ]; then 
	rm -rf /var/lib/alertmanager
fi
rm /usr/local/bin/alertmanager
rm /usr/local/bin/amtool
ok "Done"


info "Removing systemd service..."
rm /etc/systemd/system/alertmanager.service
systemctl daemon-reload
ok "Uninstalled alertmanager successfully!"
