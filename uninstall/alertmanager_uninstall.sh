#!/bin/bash

source ./utils.sh

check_root
check_local_package alertmanager absent


show_help() {
	echo -e "Usage: ./alertmanager_uninstall [OPTIONS] \n\tOPTIONS:\n\t\t -f\tdelete directories without asking"
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
info "Stopping and disabling alertmanager service..."
run_notify "systemctl stop alertmanager &> /dev/null"
run_notify "systemctl disable alertmanager"
ok "Done"

if [ "$FORCE_DELETE_USER_DIRS" = true ]; then
	info "Removing user, group and deleting directories..."
else
	USER_ANS=$(prompt_yes_no 'Do you want to remove alertmanager user? (yes/no): ')
	CONF_DIR_ANS=$(prompt_yes_no 'Do you want to remove alertmanager config directory? (yes/no): ')
	LIB_DIR_ANS=$(prompt_yes_no 'Do you want to remove alertmanager lib directory? (yes/no): ')
fi



if [[ $USER_ANS == 'yes' || "$FORCE_DELETE_USER_DIRS" = true ]]; then
	#### Remove prometheus user 
	info "Removing alertmanager user..."
	run_notify "deluser alertmanager"
	ok "Done"
fi


info "Deleting binaries..."
if [[ $CONF_DIR_ANS == 'yes' || "$FORCE_DELETE_USER_DIRS" = true ]]; then
	rm -rf /etc/alertmanager
fi
if [[ $LIB_DIR_ANS == 'yes' || "$FORCE_DELETE_USER_DIRS" = true ]]; then 
	rm -rf /var/lib/alertmanager
fi
rm /usr/local/bin/alertmanager
rm /usr/local/bin/amtool
ok "Done"


info "Removing systemd service..."
rm /etc/systemd/system/alertmanager.service
systemctl daemon-reload
ok "Uninstalled alertmanager successfully!"
