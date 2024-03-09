#!/bin/bash

source ./utils.sh

check_local_package node_exporter absent

#### First stop service
info "Stopping and disabling node_exporter service..."
run_notify "systemctl stop node_exporter &> /dev/null"
run_notify "systemctl disable node_exporter"
ok "Done"

#### Remove node_exporter user 
info "Removing node_exporter user..."
run_notify "deluser node_exporter"
ok "Done"

rm /usr/local/bin/node_exporter

info "Removing systemd service..."
rm /etc/systemd/system/node_exporter.service
run_notify "systemctl daemon-reload"
ok "Uninstalled node exporter sucessfully!"
