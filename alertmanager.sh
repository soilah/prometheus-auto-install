#!/bin/bash

source ./utils.sh

check_root
check_local_package alertmanager exists

check_user alertmanager

check_package wget
check_package curl


info "Creating directories and files"
# Make directories and dummy files necessary for alertmanager
mkdir /etc/alertmanager
mkdir /etc/alertmanager/template
mkdir -p /var/lib/alertmanager/data
touch /etc/alertmanager/alertmanager.yml
ok "Done"


info "Setting permissions..."
chown -R alertmanager:alertmanager /etc/alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager
ok "Done"



## Get cpu architecture (amd64 for pc, arm64 for rpi)
ARCH=$(check_arch)
if [ $ARCH == "arm64" ]; then
	info "Installing for Raspberry pi..."
fi


## Get latest version

#VERSION=$(curl https://raw.githubusercontent.com/prometheus/alertmanager/master/VERSION --silent)
#### with previous technique, the rc version was selected for some reason.

VERSION=$(curl -sqI https://github.com/prometheus/alertmanager/releases/latest  | grep tag | rev | cut -d '/' -f 1 | rev | cut -c2- | tr -d '\r\n')
info "Downloading latest version... ($VERSION)"
wget https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-${ARCH}.tar.gz &> /dev/null
tar xvzf alertmanager-${VERSION}.linux-${ARCH}.tar.gz &> /dev/null

info "Extracting and copying binaries to /usr/local/bin"
cp alertmanager-${VERSION}.linux-${ARCH}/alertmanager /usr/local/bin/
cp alertmanager-${VERSION}.linux-${ARCH}/amtool /usr/local/bin/

info "Setting permissions..."
chown alertmanager:alertmanager /usr/local/bin/alertmanager
chown alertmanager:alertmanager /usr/local/bin/amtool

info "Creating initial configuration files..."
# Populate configuration files
cat ./alertmanager/alertmanager.yml | tee /etc/alertmanager/alertmanager.yml &> /dev/null

info "Creating service file"
cat ./service_files/alertmanager.service | tee /etc/systemd/system/alertmanager.service &> /dev/null

info "Reloading systemd, enabling and starting service"
# systemd
systemctl daemon-reload &> /dev/null
systemctl enable alertmanager &> /dev/null
systemctl start alertmanager &> /dev/null

info "Removing files..."
# Installation cleanup
rm alertmanager-${VERSION}.linux-${ARCH}.tar.gz
rm -rf alertmanager-${VERSION}.linux-${ARCH}

info "Alertmanager installed sucessfully"
