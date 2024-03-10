#!/bin/bash

source ./utils.sh

check_root
check_open_port 9090
check_local_package prometheus exists

check_user prometheus
check_package wget
check_package curl

info "Creating directories and files"
# Make directories and dummy files necessary for prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus
touch /etc/prometheus/prometheus.yml
touch /etc/prometheus/prometheus.rules.yml
ok "Done"

info "Setting permissions..."
#### Change permissions to prometheus user
chown -R prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
ok "Done"

info "Downloading latest version..."
## Get latest version
VERSION=$(curl https://raw.githubusercontent.com/prometheus/prometheus/master/VERSION --silent)
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz &> /dev/null

info "Extracting and copying binaries to /usr/local/bin"
tar xvzf prometheus-${VERSION}.linux-amd64.tar.gz &> /dev/null
cp prometheus-${VERSION}.linux-amd64/prometheus /usr/local/bin/
cp prometheus-${VERSION}.linux-amd64/promtool /usr/local/bin/

info "Creating directories..."
cp -r prometheus-${VERSION}.linux-amd64/consoles /etc/prometheus
cp -r prometheus-${VERSION}.linux-amd64/console_libraries /etc/prometheus

info "Setting permissions..."
# Assign the ownership of the tools above to prometheus user
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool


info "Creating initial configuration files..."
# Populate configuration files
cat ./prometheus/prometheus.yml | tee /etc/prometheus/prometheus.yml &> /dev/null
cat ./prometheus/prometheus.rules.yml | tee /etc/prometheus/prometheus.rules.yml &> /dev/null

info "Creating service file"
#### Create service file, reload systemd, enable and start service.
cat ./prometheus/prometheus.service | tee /etc/systemd/system/prometheus.service &> /dev/null

info "Reloading systemd, enabling and starting sercice"
systemctl daemon-reload &> /dev/null
systemctl enable prometheus &> /dev/null
systemctl start prometheus &> /dev/null

info "Removing files..."
# Installation cleanup
rm prometheus-${VERSION}.linux-amd64.tar.gz
rm -rf prometheus-${VERSION}.linux-amd64

ok "Prometheus installed sucessfully!"
