#!/bin/bash

source ./utils.sh

#### First stop service
info "Stopping and disabling node_exporter service..."
run_notify "systemctl stop node_exporter &> /dev/null"
run_notify "systemctl disable node_exporter"
ok "Done"

#### Remove prometheus user 
run_notify "deluser prometheus"

rm /usr/local/bin/node_exporter

rm /etc/systemd/system/node_exporter.service
run_notify "systemctl daemon-reload"
ok "Uninstalled node exporter sucessfully!"
