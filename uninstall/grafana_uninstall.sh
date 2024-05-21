#!/bin/bash

source ./utils.sh

check_root
check_local_package grafana-server absent

show_help() {
	echo -e "Usage: ./grafana_uninstall [OPTIONS] \n\tOPTIONS:\n\t\t -f\tdelete directories without asking"
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

info "Removing grafana..."
apt-get purge grafana -y &> /dev/null
info "Removing files..."


if [ "$FORCE_DELETE_USER_DIRS" = true ]; then
	info "Removing user, group and deleting directories..."
else
	CONF_DIR_ANS=$(prompt_yes_no 'Do you want to remove grafana CONFIG directory? (yes/no): ')
	DATA_DIR_ANS=$(prompt_yes_no 'Do you want to remove grafana DATA directory containing the grafana database (dashboards, datasources etc.) ? (yes/no): ')
fi


if [[ $CONF_DIR_ANS == 'yes' || "$FORCE_DELETE_USER_DIRS" = true ]]; then
	rm -r /etc/grafana
fi
if [[ $DATA_DIR_ANS == 'yes' || "$FORCE_DELETE_USER_DIRS" = true ]]; then
	rm -r /var/lib/grafana
fi
ok "Done"
