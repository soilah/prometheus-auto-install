#!/bin/bash

source ./utils.sh

check_root
check_user prometheus

check_package wget
check_package curl


info "Downloading latest version..."
## Get latest version
VERSION=$(curl https://raw.githubusercontent.com/prometheus/node_exporter/master/VERSION &> /dev/null)
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz &> /dev/null
info "Extracting and copying binary to /usr/local/bin"
#### Extract binary, copy to /usr/local/bin
tar xvzf node_exporter-${VERSION}.linux-amd64.tar.gz &> /dev/null
sudo cp node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/

info "Setting permissions..."
#### Change permissions to prometheus user
sudo chown prometheus:prometheus /usr/local/bin/node_exporter

info "Creating service file"
#### Create service file, reload systemd, enable and start service.
cat ./service_files/node_exporter.service | sudo tee /etc/systemd/system/node_exporter.service &> /dev/null

info "Reloading systemd, enabling and starting sercice"
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

info "Removing files..."

# Installation cleanup
rm node_exporter-${VERSION}.linux-amd64.tar.gz
rm -rf node_exporter-${VERSION}.linux-amd64

ok "Node Exporter installed successfully!"
