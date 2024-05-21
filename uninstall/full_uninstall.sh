#!/bin/bash

source ./utils.sh

check_root

show_help() {
	echo -e "Usage: ./full_uninstall [OPTIONS] \n\tOPTIONS:\n\t\t -f\tdelete directories without asking"
} 

OPTIONS=""

FORCE_DELETE_USER_DIRS=false
if [ "$#" -gt 1 ]; then
	show_help
	exit
elif [ "$#" -eq 1 ]; then
	if [ $1 == '-f' ]; then
		FORCE_DELETE_USER_DIRS=true
		OPTIONS+=' -f'
	else
		show_help
		exit
	fi
fi

echo $OPTIONS

new "#######################"
new "UNINSTALLING PROMETHEUS"
new "#######################"
./uninstall/prometheus_uninstall.sh $OPTIONS
new "##########################"
new "UNINSTALLING NODE EXPORTER"
new "##########################"
./uninstall/node_uninstall.sh $OPTIONS
new "#########################"
new "UNINSTALLING ALERTMANAGER"
new "#########################"
./uninstall/alertmanager_uninstall.sh $OPTIONS
new "####################"
new "UNINSTALLING GRAFANA"
new "####################"
./uninstall/grafana_uninstall.sh $OPTIONS
ok "DONE UNINSTALLING PROMETHEUS SUITE."

#./blackbox_uninstall.sh

