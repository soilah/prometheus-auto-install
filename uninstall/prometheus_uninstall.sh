#!/bin/bash

source ./utils.sh


check_local_package prometheus absent

#### First stop service
info "Stopping and disabling prometheus service..."
run_notify "systemctl stop prometheus &> /dev/null"
run_notify "systemctl disable prometheus"
ok "Done"

#### Remove prometheus user 
info "Removing prometheus user..."
run_notify "deluser prometheus"
ok "Done"


info "Deleting directories and binaries..."
rm -rf /etc/prometheus
rm -rf /var/lib/prometheus
rm /usr/local/bin/prometheus
rm /usr/local/bin/promtool
ok "Done"


info "Removing systemd service..."
rm /etc/systemd/system/prometheus.service
systemctl daemon-reload
ok "Uninstalled prometheus sucessfully!"
