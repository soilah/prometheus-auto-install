#!/bin/bash

source ./utils.sh

check_local_package alertmanager absent


#### First stop service
info "Stopping and disabling alertmanager service..."
run_notify "systemctl stop alertmanager &> /dev/null"
run_notify "systemctl disable alertmanager"
ok "Done"

#### Remove prometheus user 
info "Removing alertmanager user..."
#run_notify "deluser alertmanager"
ok "Done"


info "Deleting directories and binaries..."
sudo rm -rf /etc/alertmanager
sudo rm -rf /var/lib/alertmanager/data
sudo rm /usr/local/bin/alertmanager
sudo rm /usr/local/bin/amtool
ok "Done"


info "Removing systemd service..."
sudo rm /etc/systemd/system/alertmanager.service
sudo systemctl daemon-reload
ok "Uninstalled alertmanager successfully!"
