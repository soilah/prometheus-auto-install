#!/bin/bash

source ./utils.sh

check_root
check_local_package grafana exists
check_package libfontconfig
check_package musl

# Download grafana
info "Downloading latest grafana..."
LATEST=$(curl https://grafana.com/grafana/download?edition=oss --silent | grep wget | grep amd64.deb | grep -o -P '(?<=href=").*(?=">https)')
wget $LATEST &> /dev/null

# Install grafana
info "Installing grafana..."
dpkg -i grafana_latest_amd64.deb &> /dev/null
ok "Done"


info "Reloading systemd, enabling and starting sercice"
systemctl daemon-reload &> /dev/null
systemctl enable grafana-server &> /dev/null
systemctl start grafana-server &> /dev/null

info "Removing files..."
# Installation cleanup
rm grafana_4.6.3_amd64.deb
ok "Grafana installed sucessfully!"
