#!/bin/bash

source ./utils.sh

check_root
check_local_package prometheus absent

#### First stop service
info "Stopping and disabling prometheus service..."
run_notify "systemctl stop prometheus &> /dev/null"
run_notify "systemctl disable prometheus"
ok "Done"


USER_ANS=$(prompt_yes_no 'Do you want to remove prometheus user? (yes/no): ')

if [ $USER_ANS == 'yes' ]; then
	#### Remove prometheus user 
	info "Removing prometheus user..."
	run_notify "deluser prometheus"
	ok "Done"
fi

CONF_DIR_ANS=$(prompt_yes_no 'Do you want to remove prometheus config directory? (yes/no): ')
if [ $CONF_DIR_ANS == 'yes' ]; then
	info "Deleting config directory..."
	rm -rf /etc/prometheus
	ok "Done"
fi


DATA_DIR_ANS=$(prompt_yes_no 'Do you want to remove prometheus data directory? (yes/no): ')
if [ $DATA_DIR_ANS == 'yes' ]; then
	info "Deleting data directory..."
	rm -rf /var/lib/prometheus
	ok "Done"
fi


info "Deleting binaries..."
rm /usr/local/bin/prometheus
rm /usr/local/bin/promtool
ok "Done"


info "Removing systemd service..."
rm /etc/systemd/system/prometheus.service
systemctl daemon-reload
ok "Uninstalled prometheus sucessfully!"
