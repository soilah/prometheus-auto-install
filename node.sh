#!/bin/bash

source ./utils.sh

check_root
check_local_package node_exporter exists
check_open_port 9100


check_user node_exporter

check_package wget
check_package curl


## Get cpu architecture (amd64 for pc, arm64 for rpi)
ARCH=$(check_arch)
if [ $ARCH == "arm64" ]; then
	info "Installing for Raspberry pi..."
fi

## Get latest version
#VERSION=$(curl https://raw.githubusercontent.com/prometheus/node_exporter/master/VERSION --silent)
VERSION=$(curl -sqI https://github.com/prometheus/node_exporter/releases/latest  | grep tag | rev | cut -d '/' -f 1 | rev | cut -c2- | tr -d '\r\n')
info "Downloading latest version... ($VERSION)"
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-${ARCH}.tar.gz &> /dev/null
info "Extracting and copying binary to /usr/local/bin"
#### Extract binary, copy to /usr/local/bin
tar xvzf node_exporter-${VERSION}.linux-${ARCH}.tar.gz &> /dev/null
sudo cp node_exporter-${VERSION}.linux-${ARCH}/node_exporter /usr/local/bin/

info "Setting permissions..."
#### Change permissions to prometheus user
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

info "Creating service file"
#### Create service file, reload systemd, enable and start service.
cat ./service_files/node_exporter.service | sudo tee /etc/systemd/system/node_exporter.service &> /dev/null

info "Reloading systemd, enabling and starting service"
sudo systemctl daemon-reload &> /dev/null
sudo systemctl enable node_exporter &> /dev/null
sudo systemctl start node_exporter &> /dev/null

info "Removing files..."

# Installation cleanup
rm node_exporter-${VERSION}.linux-${ARCH}.tar.gz
rm -rf node_exporter-${VERSION}.linux-${ARCH}

ok "Node Exporter installed successfully!"
