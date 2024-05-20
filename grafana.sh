#!/bin/bash

source ./utils.sh

check_root
check_open_port 3000
check_local_package grafana exists
check_package libfontconfig
check_package musl


## Get cpu architecture (amd64 for pc, arm64 for rpi)
PLATFORM="linux"
ARCH=$(check_arch)
if [ $ARCH == "arm64" ]; then
	info "Installing for Raspberry pi..."
	PLATFORM="arm"
fi



# Download grafana
info "Downloading latest grafana..."
LATEST=$(curl 'https://grafana.com/grafana/download?edition=oss&platform='"$PLATFORM"'' --silent | grep wget | grep ${ARCH}.deb | grep -o -P '(?<=href=").*(?=">https)')
wget $LATEST &> /dev/null

# Install grafana
LOCAL_DEB=$(echo $LATEST | cut -d'/' -f 6)
VERSION=$(echo $LATEST | cut -d'/' -f 6 | cut -d'_' -f 2)

info "Installing grafana (version $VERSION)..."
dpkg -i $LOCAL_DEB &> /dev/null
ok "Done"


info "Reloading systemd, enabling and starting service"
systemctl daemon-reload &> /dev/null
systemctl enable grafana-server &> /dev/null
systemctl start grafana-server &> /dev/null

info "Removing files..."
# Installation cleanup
rm $LOCAL_DEB
ok "Grafana installed sucessfully!"
