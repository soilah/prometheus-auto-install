#!/bin/bash

source ./utils.sh

check_root
check_local_package grafana-server absent

info "Removing grafana..."
apt-get purge grafana -y &> /dev/null
info "Removing files..."
CONF_DIR_ANS=$(prompt_yes_no 'Do you want to remove grafana CONFIG directory? (yes/no): ')
if [ $CONF_DIR_ANS == 'yes' ]; then
	rm -r /etc/grafana
fi
DATA_DIR_ANS=$(prompt_yes_no 'Do you want to remove grafana DATA directory containing the grafana database (dashboards, datasources etc.) ? (yes/no): ')
if [ $DATA_DIR_ANS == 'yes' ]; then
	rm -r /var/lib/grafana
fi
ok "Done"
