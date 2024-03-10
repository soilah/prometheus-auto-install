#!/bin/bash

source ./utils.sh

check_root
check_open_port 3000
check_local_package grafana exists
check_package libfontconfig
check_package musl

# Download grafana
info "Downloading latest grafana..."
LATEST=$(curl https://grafana.com/grafana/download?edition=oss --silent | grep wget | grep amd64.deb | grep -o -P '(?<=href=").*(?=">https)')
wget $LATEST &> /dev/null

# Install grafana
LOCAL_DEB=$(echo $LATEST | cut -d'/' -f 6)
VERSION=$(echo $LATEST | cut -d'/' -f 6 | cut -d'_' -f 2)
info "Installing grafana (version $VERSION)..."
dpkg -i $LOCAL_DEB &> /dev/null
ok "Done"


info "Reloading systemd, enabling and starting sercice"
systemctl daemon-reload &> /dev/null
systemctl enable grafana-server &> /dev/null
systemctl start grafana-server &> /dev/null

info "Removing files..."
# Installation cleanup
rm $LOCAL_DEB
ok "Grafana installed sucessfully!"
