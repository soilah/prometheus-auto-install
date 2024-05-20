#!/bin/bash

source ./utils.sh

check_root
check_local_package grafana-server absent

info "Removing grafana..."
apt-get purge grafana -y &> /dev/null
info "Removing files..."
rm -r /var/lib/grafana
rm -r /etc/grafana
ok "Done"
