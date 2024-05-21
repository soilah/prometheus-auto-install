#!/bin/bash

source ./utils.sh

check_root
check_local_package prometheus absent


show_help() {
	echo -e "Usage: ./prometheus_uninstall [OPTIONS] \n\tOPTIONS:\n\t\t -f\tdelete directories without asking"
} 


FORCE_DELETE_USER_DIRS=false
if [ "$#" -gt 1 ]; then
	show_help
	exit
elif [ "$#" -eq 1 ]; then
	if [ $1 == '-f' ]; then
		FORCE_DELETE_USER_DIRS=true
	else
		show_help
		exit
	fi
fi

#### First stop service
info "Stopping and disabling prometheus service..."
run_notify "systemctl stop prometheus &> /dev/null"
run_notify "systemctl disable prometheus"
ok "Done"


if [ "$FORCE_DELETE_USER_DIRS" = true ]; then
	info "Removing user, group and deleting directories..."
else
	USER_ANS=$(prompt_yes_no 'Do you want to remove prometheus user? (yes/no): ')
	CONF_DIR_ANS=$(prompt_yes_no 'Do you want to remove prometheus config directory? (yes/no): ')
	DATA_DIR_ANS=$(prompt_yes_no 'Do you want to remove prometheus data directory? (yes/no): ')
fi

if [[ $USER_ANS == 'yes'  ||  "$FORCE_DELETE_USER_DIRS" = true ]]; then
	#### Remove prometheus user 
	info "Removing prometheus user..."
	run_notify "deluser prometheus"
	ok "Done"
fi

if [[ $CONF_DIR_ANS == 'yes'  ||  "$FORCE_DELETE_USER_DIRS" = true ]]; then
	info "Deleting config directory..."
	rm -rf /etc/prometheus
	ok "Done"
fi


if [[ $DATA_DIR_ANS == 'yes'  ||  "$FORCE_DELETE_USER_DIRS" = true ]]; then
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
