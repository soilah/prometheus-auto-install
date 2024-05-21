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


NEW_CONF_DIR=true
NEW_DATA_DIR=true

if [ -d "/etc/prometheus" ]; then
	warn "Default configuration directory /etc/prometheus already exists..."
	NEW_CONF_DIR=false
else
	mkdir -p /etc/prometheus/rules
	touch /etc/prometheus/prometheus.yml
	touch /etc/prometheus/rules/rules.yml
fi


if [ -d "/var/lib/prometheus" ]; then
	warn "Default data directory /var/lib/prometheus already exists..."
	NEW_DATA_DIR=false
else
	mkdir /var/lib/prometheus
fi

ok "Done"

info "Setting permissions..."
#### Change permissions to prometheus user
chown -R prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
ok "Done"


## Get cpu architecture (amd64 for pc, arm64 for rpi)
ARCH=$(check_arch)
if [ $ARCH == "arm64" ]; then
	info "Installing for Raspberry pi..."
fi


## Get latest version

#VERSION=$(curl https://raw.githubusercontent.com/prometheus/prometheus/master/VERSION --silent)
#### with previous technique, the rc version was selected for some reason.

VERSION=$(curl -sqI https://github.com/prometheus/prometheus/releases/latest  | grep tag | rev | cut -d '/' -f 1 | rev | cut -c2- | tr -d '\r\n')
info "Downloading latest version... ($VERSION)"
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-${ARCH}.tar.gz &> /dev/null

info "Extracting and copying binaries to /usr/local/bin"
tar xvzf prometheus-${VERSION}.linux-${ARCH}.tar.gz &> /dev/null
cp prometheus-${VERSION}.linux-${ARCH}/prometheus /usr/local/bin/
cp prometheus-${VERSION}.linux-${ARCH}/promtool /usr/local/bin/


if [ "$NEW_CONF_DIR" = true ]; then
	info "Creating directories..."
	cp -r prometheus-${VERSION}.linux-${ARCH}/consoles /etc/prometheus
	cp -r prometheus-${VERSION}.linux-${ARCH}/console_libraries /etc/prometheus

	info "Creating initial configuration files..."
	# Populate configuration files
	cat ./prometheus/prometheus.yml | tee /etc/prometheus/prometheus.yml &> /dev/null
	cat ./prometheus/prometheus.rules.yml | tee /etc/prometheus/rules/rules.yml &> /dev/null
fi

info "Setting permissions..."
# Assign the ownership of the tools above to prometheus user
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool


info "Creating service file"
#### Create service file, reload systemd, enable and start service.
cat ./service_files/prometheus.service | tee /etc/systemd/system/prometheus.service &> /dev/null

info "Reloading systemd, enabling and starting service"
systemctl daemon-reload &> /dev/null
systemctl enable prometheus &> /dev/null
systemctl start prometheus &> /dev/null

info "Removing files..."
# Installation cleanup
rm prometheus-${VERSION}.linux-${ARCH}.tar.gz
rm -rf prometheus-${VERSION}.linux-${ARCH}

ok "Prometheus installed sucessfully!"
